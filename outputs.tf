output "vms" {
  value = [
    for index, vm in opennebula_virtual_machine.rancher_node :
    {
      name = vm.name
      ip   = vm.nic.0.computed_ip
    }
  ]
}


output "fullstacks_rancher_server_url" {
  value = var.rancher_server_url
}