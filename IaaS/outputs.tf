output "web_public_ip" {
  value = azurerm_public_ip.web_public_ip.ip_address
}

output "web_private_ip" {
  value = azurerm_network_interface.web_nic.private_ip_address

}
