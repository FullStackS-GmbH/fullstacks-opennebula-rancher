variable "output_path" {
  type        = string
  description = "Path to output directory"
  default     = "./output"
}

variable "one_endpoint" {
    type = string
    description = "URL of OpenNebula XMLRPC API"
}

variable "one_username" {
    type = string
    description = "OpenNebula Username"
    sensitive = true
}

variable "one_password" {
    type = string
    description = "OpenNebula User Password"
    sensitive = true
}

variable "vm_cpu" {
    type = number
    description = "Count of VM CPU Cores"
    default = 2
}

variable "vm_ram" {
    type = number
    description = "MB of VM RAM"
    default = 4096
}

variable "vm_name" {
    type = string
    description = "Name Prefix of VM"
}

variable "vm_template" {
    type = string
    description = "Name of OpenNebula VM Template"  
}

variable "vm_network" {
    type = string
    description = "Name of OpenNebula VNet"
  
}

variable "vm_count" {
    type = number
    description = "Count of VMs"
    default = 1
  
}

variable "rancher_cluster_cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "rancher_service_cidr" {
  type    = string
  default = "10.43.0.0/16"
}

variable "kubernetes_version" {
  type    = string
  default = "v1.20.13-rancher1-1"
}

variable "rancher_version" {
  type    = string
  default = "2.6.4"
}

variable "rancher_server_url" {
  type        = string
  description = "Rancher Server URL"
  default     = "rancher-oneconf22.fullstacks.cloud"
}

variable "rancher_password" {
    type = string
    default = "rancher"
    sensitive = true
}