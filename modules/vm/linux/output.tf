output "name" {
  value = azurerm_linux_virtual_machine.this.*.name
}

output "vm_info" {
  value = [
    for vm in azurerm_linux_virtual_machine.this : {
      id         = vm.id
      nic_ids    = vm.network_interface_ids
      private_ip = vm.private_ip_address
    }
  ]
}
