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
  count         = var.iaas_deploy == 1 ? 1 : 0
  source        = "./../modules/networks/vnet"
  infra_type    = "iaas-${var.infra_type}"
  rg_name       = module.network_rg.name
  rg_location   = var.rg_location
  address_space = var.iaas_vnet_address_space
}

# Peer Bastion VNet with Web VNet
resource "terraform_data" "replace_bastion_peering" {
  depends_on = [ module.iaas_vnet ]
  count = var.iaas_deploy == 1 ? 1 : 0
  input = module.iaas_vnet[0].network_id
}

resource "azurerm_virtual_network_peering" "bastion_to_web" {
  depends_on = [ module.iaas_vnet ]
  name                      = "bastion-to-web"
  resource_group_name       = module.bastion.bastion_rg_name
  virtual_network_name      = module.bastion.bastion_vnet
  remote_virtual_network_id = module.iaas_vnet[0].network_id

  lifecycle {
    replace_triggered_by = [ terraform_data.replace_bastion_peering ]
  }
}

resource "azurerm_virtual_network_peering" "web_to_bastion" {
  depends_on = [ module.iaas_vnet ]
  name                      = "web-to-bastion"
  resource_group_name       = module.network_rg.name
  virtual_network_name      = module.iaas_vnet[0].network_name
  remote_virtual_network_id = module.bastion.bastion_vnet_id
}

# Create subnets
resource "azurerm_subnet" "iaas_subnets" {
  for_each             = var.iaas_subnets_map
  name                 = "${each.key}-subnet"
  resource_group_name  = module.network_rg.name
  virtual_network_name = module.iaas_vnet[0].network_name
  address_prefixes     = each.value
}
