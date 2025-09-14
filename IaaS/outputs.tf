output "iaas_rg_name" {
  value = module.iaas_rg.name
}

output "network_rg_name" {
  value = module.network_rg.name
}

output "vnet_name" {
  value = module.web_vnet.network_name
}

output "nsg_name" {
  value = module.web_nsg.nsg_name
}

output "nsg_rules" {
  value = module.web_nsg.security_rules
}
output "web_public_ip" {
  value = azurerm_public_ip.web_public_ip.ip_address
}

output "web_private_ip" {
  value = azurerm_network_interface.web_nic.private_ip_address
}

output "web_a_record_fqdn" {
  value = azurerm_dns_a_record.web_a_record.fqdn
}

