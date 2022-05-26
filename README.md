# fullstacks-opennebula-rancher

![FullStackS GmbH](https://static.wixstatic.com/media/09b67c_95629a63c35b44f581d199a824b2e99d~mv2.png/v1/fill/w_494,h_106,al_c,q_85,usm_0.66_1.00_0.01/Logo_final-01-removebg-preview.webp )

![OpenNebula Systems](https://opennebula.io/wp-content/uploads/2020/04/opennebula_cloud_logo_white_bg.svg )

## Who we are

FullStackS is your trusted partner for your digital transformation. We offer a wide range of consulting and integration services with a focus on application performance monitoring and management as well as automation of your workloads at the edge, in the core and in the cloud.

With our expertise, we support you in word and deed in the modernization of your applications from monoliths to containers and microservices, while keeping your business goals permanently in the focus of all our actions.

We optimize your application, software and infrastructure landscape sustainably and provide you with all the tools and know-how you need for your digital success.

Our range of services includes the "FullStack" from code to infrastructure.

We deliver measurable results in a short timeframe and work closely with world-leading vendors such as Cisco / AppDynamics, SuSE / Rancher Labs and others.

https://www.fullstacks.eu/


## Use Case

This mockup is used for OpenNebulaCon22 together
with our partner OpenNebula Systems showcasing a new approach OpenNebula in the Enterprise.

We have developed this mockup to show what a powerful engine you have in your data centre with OpenNebula.

With the combination of OpenNebula and an IaC approach (e.g. with Terraform), you no longer have to be afraid of any IT requirement. Also in the enterprise.


***Warning***

This is not fail-safe and production ready.
It is an mockup for showcasing possibilites.
In production we run those automations with a different approach.

AGAIN: THIS IS AN MOCKUP - DO NOT USE IN PRODUCTION !!

Interested? - Contact us! office@fullstacks.eu - https://www.fullstacks.eu

***We show you how to get maximum benefit from [OpenNebula](https://opennebula.io/), [Terraform](https://www.terraform.io/) and [SUSE Rancher](https://www.suse.com/en-en/products/suse-rancher/).***

## How-To

- Set OpenNebula API and Credentials
- Pick your VM Template (must be Ubuntu 20.04) and VNet
- Set your Rancher Variables
- Do a Terraform init,plan and apply

We tested with OpenNebula LTS and SUSE Rancher 2.6.5.

This Terraform creates you a HA Rancher Management Server on your OpenNebula. 

- 3 VMs
- 1 HA Rancher RKE K8S Cluster on top of the 3 VMs
- 1 HA Rancher Server on top of the RKE K8S Cluster


It creates you:

- an `./output` folder with all you need (SSH-Keys, KubeConfig, RKE Config)

and it outputs you the details of your Rancher deployment in your OpenNebula:

```
Changes to Outputs:
  + fullstacks_rancher_server_url = "fullstacks-rancher.fullstacks.cloud"
  + vms                           = [
      + {
          + ip   = (known after apply)
          + name = "fullstacks-rancher-01"
        },
      + {
          + ip   = (known after apply)
          + name = "fullstacks-rancher-02"
        },
      + {
          + ip   = (known after apply)
          + name = "fullstacks-rancher-03"
        },
    ]
```



## Terraform Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opennebula"></a> [opennebula](#requirement\_opennebula) | 0.4.3 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 1.23.0 |
| <a name="requirement_rke"></a> [rke](#requirement\_rke) | 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |
| <a name="provider_opennebula"></a> [opennebula](#provider\_opennebula) | 0.4.3 |
| <a name="provider_rke"></a> [rke](#provider\_rke) | 1.3.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.7.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.rancher](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rke_state_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rkeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh_public_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [opennebula_virtual_machine.rancher_node](https://registry.terraform.io/providers/OpenNebula/opennebula/0.4.3/docs/resources/virtual_machine) | resource |
| [rke_cluster.cluster](https://registry.terraform.io/providers/rancher/rke/1.3.0/docs/resources/cluster) | resource |
| [time_sleep.wait_for_cert_manager](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [opennebula_template.vmtemplate](https://registry.terraform.io/providers/OpenNebula/opennebula/0.4.3/docs/data-sources/template) | data source |
| [opennebula_virtual_network.vmnetwork](https://registry.terraform.io/providers/OpenNebula/opennebula/0.4.3/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `"v1.20.13-rancher1-1"` | no |
| <a name="input_one_endpoint"></a> [one\_endpoint](#input\_one\_endpoint) | URL of OpenNebula XMLRPC API | `string` | n/a | yes |
| <a name="input_one_password"></a> [one\_password](#input\_one\_password) | OpenNebula User Password | `string` | n/a | yes |
| <a name="input_one_username"></a> [one\_username](#input\_one\_username) | OpenNebula Username | `string` | n/a | yes |
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | Path to output directory | `string` | `"./output"` | no |
| <a name="input_rancher_cluster_cidr"></a> [rancher\_cluster\_cidr](#input\_rancher\_cluster\_cidr) | n/a | `string` | `"10.42.0.0/16"` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | n/a | `string` | `"rancher"` | no |
| <a name="input_rancher_server_url"></a> [rancher\_server\_url](#input\_rancher\_server\_url) | Rancher Server URL | `string` | `"rancher.fullstacks.cloud"` | no |
| <a name="input_rancher_service_cidr"></a> [rancher\_service\_cidr](#input\_rancher\_service\_cidr) | n/a | `string` | `"10.43.0.0/16"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | n/a | `string` | `"2.6.5"` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | Count of VMs | `number` | `1` | no |
| <a name="input_vm_cpu"></a> [vm\_cpu](#input\_vm\_cpu) | Count of VM CPU Cores | `number` | `2` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name Prefix of VM | `string` | n/a | yes |
| <a name="input_vm_network"></a> [vm\_network](#input\_vm\_network) | Name of OpenNebula VNet | `string` | n/a | yes |
| <a name="input_vm_ram"></a> [vm\_ram](#input\_vm\_ram) | MB of VM RAM | `number` | `4096` | no |
| <a name="input_vm_template"></a> [vm\_template](#input\_vm\_template) | Name of OpenNebula VM Template | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fullstacks_rancher_server_url"></a> [fullstacks\_rancher\_server\_url](#output\_fullstacks\_rancher\_server\_url) | n/a |
| <a name="output_vms"></a> [vms](#output\_vms) | n/a |
<!-- END_TF_DOCS -->



