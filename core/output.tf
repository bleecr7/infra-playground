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

output "bastion_info" {
  value = {
    "name"    = module.bastion.bastion_name
    "vnet"    = module.bastion.bastion_vnet
    "vnet_id" = module.bastion.bastion_vnet_id
    "rg_name" = module.bastion.bastion_rg_name
  }
}