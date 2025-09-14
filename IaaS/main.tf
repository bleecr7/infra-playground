# Generate random ID for unique naming
module "random_id" {
  source = "./../modules/random"
}

# Create network resource group
module "network_rg" {
  source      = "./../modules/rg"
  rg_location = var.rg_location
  infra_type  = "network"
}

# Create VM virtual network
module "web_vnet" {
  source        = "./../modules/networks/vnet"
  rg_name       = module.network_rg.name
  rg_location   = var.rg_location
  address_space = ["10.0.0.0/16"]
}

# Get Bastion Info
data "tfe_outputs" "bastion_info" {
  organization = "brandon-lee-private-org"
  workspace    = "core-services"
}

# Peer Bastion VNet with Web VNet
resource "azurerm_virtual_network_peering" "bastion_to_web" {
  name                      = "bastion-to-web"
  resource_group_name       = data.tfe_outputs.bastion_info.values.bastion_rg_name
  virtual_network_name      = data.tfe_outputs.bastion_info.values.bastion_vnet
  remote_virtual_network_id = module.web_vnet.network_id
}

resource "azurerm_virtual_network_peering" "web_to_bastion" {
  name                      = "web-to-bastion"
  resource_group_name       = module.network_rg.name
  virtual_network_name      = module.web_vnet.network_name
  remote_virtual_network_id = data.tfe_outputs.bastion_info.values.bastion_vnet_id
}

# Create subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet"
  resource_group_name  = module.network_rg.name
  virtual_network_name = module.web_vnet.network_name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "ag_subnet" {
  name                 = "ag-subnet"
  resource_group_name  = module.network_rg.name
  virtual_network_name = module.web_vnet.network_name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create Network Security Group and rules
locals {
  security_rules_json = file("./web_nsg_rules_linux.json")
  security_rules      = jsondecode(local.security_rules_json)
}

module "web_nsg" {
  source         = "./../modules/networks/nsg"
  infra_type     = "web"
  rg_name        = module.network_rg.name
  rg_location    = var.rg_location
  security_rules = local.security_rules
}

# Create storage resource group
module "storage_rg" {
  source      = "./../modules/rg"
  rg_location = var.rg_location
  infra_type  = "storage"
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "web_storage_account" {
  name                     = "webstorage${module.random_id.random_id}"
  location                 = var.rg_location
  resource_group_name      = module.storage_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create VM resource group
module "iaas_rg" {
  source      = "./../modules/rg"
  rg_location = var.rg_location
  infra_type  = var.infra_type
}

# Create public IPs
resource "azurerm_public_ip" "web_public_ip" {
  name                = "web-public-ip"
  location            = var.rg_location
  resource_group_name = module.iaas_rg.name
  allocation_method   = "Static"
}

data "tfe_outputs" "dns" {
  organization = "brandon-lee-private-org"
  workspace    = "core-services"
}

resource "azurerm_dns_a_record" "web_a_record" {
  name                = "@"
  zone_name           = data.tfe_outputs.dns.values.dns_domain_name
  resource_group_name = data.tfe_outputs.dns.values.dns_rg_name
  records             = [azurerm_public_ip.web_public_ip.ip_address]
  ttl                 = 300
}


# Create Linux VMs
module "web_vms" {
  source          = "./../modules/vm/linux"
  infra_type      = "web"
  vm_count        = var.unix_vm_count
  rg_name         = module.iaas_rg.name
  rg_location     = var.rg_location
  admin_password  = var.admin_password
  subnet_id       = azurerm_subnet.web_subnet.id
  public_ip_ids   = var.unix_vm_count > 0 ? [for i in range(var.unix_vm_count) : azurerm_public_ip.web_public_ip.id] : null
  storage_account = azurerm_storage_account.web_storage_account
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "web_pub_IP_NSG" {
  depends_on                = [module.web_vms]
  count                     = var.unix_vm_count
  network_interface_id      = module.web_vms.vm_info[count.index].nic_ids[0]
  network_security_group_id = module.web_nsg.nsg_id
}

# # Create Windows VMs
# module "web_vms" {
#   source          = "./../modules/vm/windows"
#   infra_type      = "web"
#   vm_count        = var.windows_vm_count
#   rg_name         = module.iaas_rg.name
#   rg_location     = var.rg_location
#   admin_password  = var.admin_password
#   subnet_id       = azurerm_subnet.web_subnet.id
#   public_ip_ids   = [for i in range(var.windows_vm_count) : azurerm_public_ip.web_public_ip.id]
#   storage_account = azurerm_storage_account.web_storage_account
#   vm_priority     = "Spot"
#   eviction_policy = "Deallocate"
# }

# # # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "web_pub_IP_NSG" {
#   depends_on                = [module.web_vms]
#   count                     = var.windows_vm_count
#   network_interface_id      = module.web_vms.vm_info[count.index].nic_ids[0]
#   network_security_group_id = module.web_nsg.nsg_id
# }

# # Install IIS web server to the virtual machine
# resource "azurerm_virtual_machine_extension" "web_server_install" {
#   depends_on                 = [module.web_vms]
#   count                      = var.windows_vm_count
#   name                       = "web-VM-wsi-ext-${count.index}"
#   virtual_machine_id         = module.web_vms.vm_info[count.index].id
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.8"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#       "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeManagementTools"
#     }
#   SETTINGS
# }
