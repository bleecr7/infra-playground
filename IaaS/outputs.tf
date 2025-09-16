output "iaas_rg_name" {
  value = module.iaas_rg.name
}

output "nsg_name" {
  value = module.web_nsg.nsg_name
}

output "vm_info" {
  value = module.web_vms.vm_info
}

output "web_a_record_fqdn" {
  value = azurerm_dns_a_record.web_a_record.fqdn
}

output "public_ip_address" {
  value = azurerm_public_ip.web_public_ip.*.ip_address
}