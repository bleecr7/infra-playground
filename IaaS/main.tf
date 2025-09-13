# Create resource group
module "rg" {
  source      = "./../modules/rg"
  rg_location = var.rg_location
  infra_type  = var.infra_type
}

module "random_id" {
  source = "./../modules/random"
}

# Create virtual network
resource "azurerm_virtual_network" "TF_vnet" {
  name                = "${var.infra_type}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.rg_location
  resource_group_name = module.rg.name
}

# Create subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.TF_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "ag_subnet" {
  name                 = "ag-subnet"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.TF_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "ag_nsg" {
  name                = "ag-nsg"
  location            = var.rg_location
  resource_group_name = module.rg.name

  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "web_storage_account" {
  name                     = "webstorage${module.random_id.random_id}"
  location                 = var.rg_location
  resource_group_name      = module.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
