# Generate random ID for unique naming
module "random_id" {
  source = "./../modules/random"
}

# Get core services info
data "tfe_outputs" "core_services" {
  organization = "brandon-lee-private-org"
  workspace    = "core-services"
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

# Create Network Security Group and rules
locals {
  security_rules_json = file("./web_nsg_rules_linux.json")
  security_rules      = jsondecode(local.security_rules_json)
}

module "web_nsg" {
  source         = "./../modules/networks/nsg"
  infra_type     = "web"
  rg_name        = module.iaas_rg.name
  rg_location    = var.rg_location
  security_rules = local.security_rules
}

# Create public IPs
resource "azurerm_public_ip" "web_public_ip" {
  count               = var.unix_vm_count
  name                = "web-public-ip-${count.index}"
  location            = var.rg_location
  resource_group_name = module.iaas_rg.name
  allocation_method   = "Static"
}

resource "azurerm_dns_a_record" "web_a_record" {
  name                = "@"
  zone_name           = data.tfe_outputs.core_services.values.dns_info["domain_name"]
  resource_group_name = data.tfe_outputs.core_services.values.dns_info["rg_name"]
  records             = [azurerm_public_ip.web_public_ip[0].ip_address]
  ttl                 = 300
}

data "azurerm_key_vault_secret" "linux_ssh_key_pub" {
  name      = "linux-ssh-pub"
  key_vault_id = data.tfe_outputs.core_services.values.key_vault_info["id"]
}

# Create Linux VMs
module "web_vms" {
  source          = "./../modules/vm/linux"
  infra_type      = "web"
  vm_count        = var.unix_vm_count
  rg_name         = module.iaas_rg.name
  rg_location     = var.rg_location
  admin_password  = var.admin_password
  subnet_id       = data.tfe_outputs.core_services.values.iaas_subnets["web-subnet"].id
  public_ip_ids   = var.unix_vm_count > 0 ? [for i in range(var.unix_vm_count) : azurerm_public_ip.web_public_ip[i].id] : null
  storage_account = azurerm_storage_account.web_storage_account

  admin_ssh_key = data.azurerm_key_vault_secret.linux_ssh_key_pub.value
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
