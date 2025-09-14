# Create resource group
resource "azurerm_resource_group" "this" {
  location = var.rg_location
  name     = "${var.infra_type}-rg"
}