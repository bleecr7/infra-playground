resource "azurerm_virtual_network" "this" {
  resource_group_name = var.rg_name
  location            = var.rg_location
  name                = "${var.infra_type}-vnet"
  address_space       = var.address_space
}