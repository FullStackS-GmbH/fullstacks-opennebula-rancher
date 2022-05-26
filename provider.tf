terraform {
  required_providers {
    opennebula = {
      source  = "OpenNebula/opennebula"
      version = "0.4.3"
    }
    helm = {
      source = "hashicorp/helm"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.3.0"
    }
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.23.0"
      
    }
  }
}

provider "opennebula" {
  endpoint = var.one_endpoint
  username = var.one_username
  password = var.one_password
}
