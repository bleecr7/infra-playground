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

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_basic_public_ip.ip_address
}