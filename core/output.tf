output "name_servers" {
  description = "NS records to configure at your domain registrar"
  value       = module.dns.azure_name_servers
}

output "dns_domain_name" {
  value = module.dns.domain_name
}

output "dns_rg_name" {
  value = module.dns.dns_rg_name
}

output "bastion_rg_name" {
  value = module.bastion.bastion_rg_name
}

output "bastion_name" {
  value = module.bastion.bastion_name 
}

output "bastion_vnet" {
  value = module.bastion.bastion_vnet
}

output "bastion_vnet_id" {
  value = module.bastion.bastion_vnet_id
}