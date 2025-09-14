module "bastion_rg" {
  source      = "./../../rg"
  infra_type  = var.infra_type
  rg_location = var.rg_location
}

module "bastion_vnet" {
  source        = "./../vnet"
  infra_type    = var.infra_type
  rg_location   = module.bastion_rg.location
  rg_name       = module.bastion_rg.name
  address_space = var.bastion_subnet_prefix
}

resource "azurerm_bastion_host" "this" {
  name                = "AzureBastionSubnet"
  location            = module.bastion_rg.location
  resource_group_name = module.bastion_rg.name
  sku                 = "Developer"
  virtual_network_id  = module.bastion_vnet.network_id
}
