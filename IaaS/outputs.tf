output "rg_name" {
  value = module.rg.name
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