# Create Azure DNS zone
module "dns" {
  source      = "./../modules/dns"
  domain_name = var.domain_name
  rg_location = var.rg_location
}

# Create Bastion host
module "bastion" {
  source      = "./../modules/networks/bastion"
  rg_location = var.rg_location
}

# Create network resource group
module "network_rg" {
  source      = "./../modules/rg"
  rg_location = var.rg_location
  infra_type  = "network"
}

# Create IaaS virtual network
module "iaas_vnet" {
  source        = "./../modules/networks/vnet"
  infra_type    = "iaas-${var.infra_type}"
  rg_name       = module.network_rg.name
  rg_location   = var.rg_location
  address_space = var.iaas_vnet_address_space
}

# Peer Bastion VNet with Web VNet
resource "azurerm_virtual_network_peering" "bastion_to_web" {
  name                      = "bastion-to-web"
  resource_group_name       = module.bastion.bastion_rg_name
  virtual_network_name      = module.bastion.bastion_vnet
  remote_virtual_network_id = module.iaas_vnet.network_id
}

resource "azurerm_virtual_network_peering" "web_to_bastion" {
  name                      = "web-to-bastion"
  resource_group_name       = module.network_rg.name
  virtual_network_name      = module.iaas_vnet.network_name
  remote_virtual_network_id = module.bastion.bastion_vnet_id
}

# Create subnets
resource "azurerm_subnet" "iaas_subnets" {
  for_each             = var.iaas_subnets_map
  name                 = "${each.key}-subnet"
  resource_group_name  = module.network_rg.name
  virtual_network_name = module.iaas_vnet.network_name
  address_prefixes     = each.value
}
