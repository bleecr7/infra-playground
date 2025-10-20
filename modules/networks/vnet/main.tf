resource "azurerm_virtual_network" "this" {
  resource_group_name = var.rg_name
  location            = var.rg_location
  name                = var.resource_name == null ? "${var.infra_type}-vnet" : var.resource_name
  address_space       = var.address_space
}