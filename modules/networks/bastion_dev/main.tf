resource "azurerm_bastion_host" "this" {
  name                = "bastion-${var.vnet_name}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "Developer"
  virtual_network_id  = var.vnet_id
}
