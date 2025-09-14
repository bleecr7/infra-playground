output "nsg_name" {
  value = azurerm_network_security_group.this.name
}

output "nsg_id" {
  value = azurerm_network_security_group.this.id
}

output "security_rules" {
  value = azurerm_network_security_group.this.security_rule
}