output "bastion_rg_name" {
  value = module.bastion_rg.name
}

output "bastion_name" {
  value = azurerm_bastion_host.this.name
}

output "bastion_id" {
  value = azurerm_bastion_host.this.id
}

output "bastion_vnet" {
  value = module.bastion_vnet.network_name
}

output "bastion_vnet_id" {
  value = module.bastion_vnet.network_id
}
