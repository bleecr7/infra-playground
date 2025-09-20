output "dns_info" {
  value = {
    domain_name        = module.dns.domain_name,
    azure_name_servers = tolist(module.dns.azure_name_servers),
    rg_name            = module.dns.dns_rg_name,
  }
}

output "bastion_info" {
  value = {
    name    = module.bastion.bastion_name,
    vnet    = module.bastion.bastion_vnet,
    vnet_id = module.bastion.bastion_vnet_id,
    rg_name = module.bastion.bastion_rg_name,
  }
}

output "key_vault_info" {
  value = {
    name = azurerm_key_vault.key_vault.name,
    id   = azurerm_key_vault.key_vault.id,
  }
}

output "linux_ssh_public_key" {
  value     = azurerm_key_vault_secret.linux_ssh_pub.value
  sensitive = true
}

output "iaas_vnet_info" {
  value = var.iaas_deploy == 1 ? {
    name          = module.iaas_vnet[0].network_name,
    id            = module.iaas_vnet[0].network_id,
    address_space = module.iaas_vnet[0].network_address_space,
    rg_name       = module.network_rg.name,
  } : null
}

output "iaas_subnets" {
  value = var.iaas_deploy == 1 ? {
    for subnet in azurerm_subnet.iaas_subnets :
    subnet.name => {
      id             = subnet.id,
      address_prefix = subnet.address_prefixes,
    }
  } : null
}