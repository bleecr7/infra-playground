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
output "vm_info" {
  value = module.web_vms.vm_info
}

output "web_a_record_fqdn" {
  value = azurerm_dns_a_record.web_a_record.fqdn
}

