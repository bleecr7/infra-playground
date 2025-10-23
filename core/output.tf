output "cloudflare_zone_info" {
  value = {
    id   = cloudflare_zone.root_domain.id,
    name = cloudflare_zone.root_domain.name,
  }
}

output "dns_info" {
  value = {
    domain_name        = module.dns.domain_name,
    azure_name_servers = tolist(module.dns.azure_name_servers),
    rg_name            = module.dns.dns_rg_name,
  }
}

output "bastion_info" {
  value = var.deploy_bastion_basic == 1 ? {
    name    = module.bastion.bastion_name,
    vnet    = module.bastion.bastion_vnet,
    vnet_id = module.bastion.bastion_vnet_id,
    rg_name = module.bastion.bastion_rg_name,
  } : null
}

output "log_analytics_info" {
  value = {
    name               = azurerm_log_analytics_workspace.core_log.name,
    id                 = azurerm_log_analytics_workspace.core_log.id,
    primary_shared_key = azurerm_log_analytics_workspace.core_log.primary_shared_key
  }
  sensitive = true
}

output "storage_account_info" {
  value = {
    rg_name = azurerm_storage_account.core_storage.resource_group_name,
    name = azurerm_storage_account.core_storage.name,
    id   = azurerm_storage_account.core_storage.id,
  }
}

output "tfstate_storage_container_info" {
  value = {
    name = azurerm_storage_container.tfstate_container.name,
    id   = azurerm_storage_container.tfstate_container.id,
  }
}

output "key_vault_info" {
  value = {
    name = azurerm_key_vault.key_vault.name,
    id   = azurerm_key_vault.key_vault.id,
  }
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