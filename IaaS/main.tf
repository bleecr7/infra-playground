# Authentication for Azure using OIDC with Terraform Cloud
provider "azurerm" {
  features {}
  client_id_file_path  = var.tfc_azure_dynamic_credentials.default.client_id_file_path
  oidc_token_file_path = var.tfc_azure_dynamic_credentials.default.oidc_token_file_path
  subscription_id      = "00000000-0000-0000-0000-000000000000"
  tenant_id            = "10000000-0000-0000-0000-000000000000"
}