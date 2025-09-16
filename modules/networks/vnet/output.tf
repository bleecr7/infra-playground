output "network_name" {
  value = azurerm_virtual_network.this.name
}

output "network_id" {
  value = azurerm_virtual_network.this.id
}

output "network_address_space" {
  value = azurerm_virtual_network.this.address_space
}