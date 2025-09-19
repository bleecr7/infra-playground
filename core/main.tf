# Create Azure DNS zone
module "dns" {
  source      = "./../modules/dns"
  domain_name = var.domain_name
  rg_location = var.rg_location
}

# Create Key Vault resource group
module "key_vault_rg" {
  source      = "./../modules/rg"
  rg_location = var.rg_location
  infra_type  = "keyvault"
}

# Generate a random ID for resource naming
module "random_id" {
  source = "./../modules/random"
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Create Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                        = "keyvault-${module.random_id.random_id}"
  location                    = var.rg_location
  resource_group_name         = module.key_vault_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "SetIssuers",
      "Update",
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
    ]
  }
}

resource "azurerm_key_vault_certificate" "cloudflare_tls" {
  name         = "cloudflare-cert"
  key_vault_id = azurerm_key_vault.key_vault.id

  certificate {
    contents = file(var.tls_cert)
    password = var.tls_cert_password
  }
}

# Create Bastion host 
# Only used if upgrading to Basic SKU - Dev SKU does not allow Bastion VNet peering transit for now
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

# Create Developer SKU Bastion host for IaaS VNet
module "bastion_dev_iaas" {
  count       = var.iaas_deploy == 1 ? 1 : 0
  source      = "./../modules/networks/bastion_dev"
  rg_name     = module.network_rg.name
  rg_location = var.rg_location
  vnet_name   = module.iaas_vnet[0].network_name
  vnet_id     = module.iaas_vnet[0].network_id
}

# Peer Bastion VNet with Web VNet
resource "terraform_data" "replace_bastion_peering" {
  depends_on = [module.iaas_vnet]
  count      = var.iaas_deploy == 1 ? 1 : 0
  input      = module.iaas_vnet[0].network_id
}

resource "azurerm_virtual_network_peering" "bastion_to_web" {
  depends_on                = [module.iaas_vnet]
  name                      = "bastion-to-web"
  resource_group_name       = module.bastion.bastion_rg_name
  virtual_network_name      = module.bastion.bastion_vnet
  remote_virtual_network_id = module.iaas_vnet[0].network_id

  lifecycle {
    replace_triggered_by = [terraform_data.replace_bastion_peering]
  }
}

resource "azurerm_virtual_network_peering" "web_to_bastion" {
  depends_on                = [module.iaas_vnet]
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
