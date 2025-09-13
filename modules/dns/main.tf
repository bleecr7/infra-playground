module "rg" {
  source   = "../rg"
  infra_type = var.infra_type
  rg_location = var.rg_location
}

resource "azurerm_dns_zone" "this" {
  name                = var.domain_name 
  resource_group_name = module.rg.name
}
