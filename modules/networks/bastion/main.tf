module "bastion_rg" {
  source      = "./../../rg"
  infra_type  = var.infra_type
  rg_location = var.rg_location
}

module "bastion_vnet" {
  source        = "./../vnet"
  resource_name = "AzureBastionVNet"
  infra_type    = var.infra_type
  rg_location   = module.bastion_rg.location
  rg_name       = module.bastion_rg.name
  address_space = var.bastion_subnet_prefix
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = module.bastion_rg.name
  virtual_network_name = module.bastion_vnet.network_name
  address_prefixes     = var.bastion_subnet_prefix
}

resource "azurerm_public_ip" "bastion_basic_public_ip" {
  name                = "bastion-basic-public-ip"
  location            = var.rg_location
  resource_group_name = module.bastion_rg.name
  allocation_method   = "Static"
}

resource "azurerm_bastion_host" "this" {
  name                = "bastion-basic"
  location            = module.bastion_rg.location
  resource_group_name = module.bastion_rg.name
  sku                 = "Basic"

  ip_configuration {
    name                 = "bastion-basic-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_basic_public_ip.id
  }
}
