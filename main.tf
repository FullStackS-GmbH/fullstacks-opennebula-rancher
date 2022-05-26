resource "tls_private_key" "key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "opennebula_virtual_machine" "rancher_node" {
  count       = var.vm_count
  name        = format("${var.vm_name}-%02d", count.index + 1)
  cpu         = var.vm_cpu
  vcpu        = var.vm_cpu
  memory      = var.vm_ram
  template_id = data.opennebula_template.vmtemplate.id
  group       = "oneadmin"
  permissions = "660"

  context = {
    HOSTNAME            = "$NAME"
    SET_HOSTNAME        = "$NAME"
    USERNAME            = "ubuntu"
    PASSWORD            = "FullStackS"
    START_SCRIPT_BASE64 = "c3dhcG9mZiAtYQpzeXNjdGwgLXcgdm0ub3ZlcmNvbW1pdF9tZW1vcnk9MQpzeXNjdGwgLXcga2VybmVsLnBhbmljPTEwCnN5c2N0bCAtdyBrZXJuZWwucGFuaWNfb25fb29wcz0xCmN1cmwgaHR0cHM6Ly9yZWxlYXNlcy5yYW5jaGVyLmNvbS9pbnN0YWxsLWRvY2tlci8ke2RvY2tlcl92ZXJzaW9ufS5zaCB8IHNoCnVzZXJtb2QgLWFHIGRvY2tlciB1YnVudHU="
    SSH_PUBLIC_KEY      = tls_private_key.key.public_key_openssh
  }

  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
    keymap = "de"
  }

#  os {
#    arch = "x86_64"
#    boot = "disk0"
#  }

  nic {
#    model      = "virtio"
    network_id = data.opennebula_virtual_network.vmnetwork.id
  }

  timeout = 10

  provisioner "remote-exec" {
    inline = [
      "sudo curl https://releases.rancher.com/install-docker/20.10.sh | sh",
      "sudo usermod -aG docker ubuntu"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.key.private_key_pem
      host        = self.nic.0.computed_ip
    }
  }

}

resource "local_file" "ssh_private_key" {
  filename        = format("${var.output_path}/id_rsa")
  content         = tls_private_key.key.private_key_pem
  file_permission = "600"
}

resource "local_file" "ssh_public_key" {
  filename        = format("${var.output_path}/id_rsa.pub")
  content         = tls_private_key.key.public_key_openssh
  file_permission = "644"
}


resource "rke_cluster" "cluster" {
  depends_on = [opennebula_virtual_machine.rancher_node]
  # 2 minute timeout specifically for rke-network-plugin-deploy-job but will apply to any addons
  addon_job_timeout  = 120
  kubernetes_version = var.kubernetes_version
  services {
    kube_api {
      service_cluster_ip_range = var.rancher_service_cidr
    }
    kube_controller {
      cluster_cidr             = var.rancher_cluster_cidr
      service_cluster_ip_range = var.rancher_service_cidr
    }
  }

  # private_registries {
  #   url        = "registry.fullstacks.eu"
  #   is_default = true
  # }

  dynamic "nodes" {
    for_each = [for vm in opennebula_virtual_machine.rancher_node : {
      name = vm["name"]
      ip   = vm["ip"]
    }]
    content {
      address           = nodes.value.ip
      hostname_override = nodes.value.name
      user              = "ubuntu"
      role              = ["controlplane", "etcd", "worker"]
      ssh_key           = tls_private_key.key.private_key_pem
    }
  }
}

resource "local_file" "kubeconfig" {
  filename = format("${var.output_path}/kubeconfig")
  content  = rke_cluster.cluster.kube_config_yaml
}

resource "local_file" "rkeconfig" {
  filename = format("${var.output_path}/cluster.yml")
  content  = rke_cluster.cluster.rke_cluster_yaml
}

resource "local_file" "rke_state_file" {
  filename = format("${var.output_path}/cluster.rkestate")
  content  = rke_cluster.cluster.rke_state
}


provider "helm" {
  kubernetes {
    config_path = format("${var.output_path}/kubeconfig")
  }
}

resource "helm_release" "cert-manager" {
  depends_on       = [local_file.kubeconfig]
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  namespace        = "cert-manager"
  create_namespace = "true"
  wait             = "true"
  replace          = true

  set {
    name  = "namespace"
    value = "cert-manager"
  }

  set {
    name  = "version"
    value = "v1.7.1"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "time_sleep" "wait_for_cert_manager" {
  depends_on      = [helm_release.cert-manager]
  create_duration = "30s"
}

resource "helm_release" "rancher" {
  depends_on       = [helm_release.cert-manager, time_sleep.wait_for_cert_manager]
  name             = "rancher"
  chart            = "rancher"
  repository       = "https://releases.rancher.com/server-charts/stable"
  namespace        = "cattle-system"
  create_namespace = "true"
  wait             = "true"
  replace          = true
  version          = var.rancher_version
  wait_for_jobs    = true
  disable_webhooks = true

  set {
    name  = "namespace"
    value = "cattle-system"
  }

  set {
    name  = "bootstrapPassword"
    value = var.rancher_password
  }

  set {
    name  = "hostname"
    value = var.rancher_server_url
  }

  set {
    name  = "ingress.tls.source"
    value = "rancher"
  }

#  set {
#    name  = "rancherImage"
#    value = "registry.fullstacks.eu/rancher/rancher"
#  }

}
