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
  location            = module.rg.location
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
  location            = module.rg.location
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

# Create network interface
resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic"
  location            = var.rg_location
  resource_group_name = module.rg.name

  ip_configuration {
    name                          = "web-nic-configuration"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.web_public_ip.id
  }
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-nsg"
  location            = module.rg.location
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

# Create public IPs
resource "azurerm_public_ip" "web_public_ip" {
  name                = "web-public-ip"
  location            = var.rg_location
  resource_group_name = module.rg.name
  allocation_method   = "Static"
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "web_pub_IP_NSG" {
  network_interface_id      = azurerm_network_interface.web_nic.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}


# Create virtual machine
resource "azurerm_windows_virtual_machine" "web_vm" {
  name                  = "web-vm"
  admin_username        = "azureuser"
  admin_password        = var.admin_password
  location              = var.rg_location
  resource_group_name   = module.rg.name
  network_interface_ids = [azurerm_network_interface.web_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "webOSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.web_storage_account.primary_blob_endpoint
  }

  provision_vm_agent = true
}

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "web-VM-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.web_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeManagementTools"
    }
  SETTINGS
}

