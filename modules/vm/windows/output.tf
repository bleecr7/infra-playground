output "name" {
  value = azurerm_windows_virtual_machine.this.*.name
}

output "vm_info" {
  value = [
    for vm in azurerm_windows_virtual_machine.this : {
        id         = vm.id
        nic_ids    = vm.network_interface_ids
        private_ip = vm.private_ip_address
    }
  ]
}
