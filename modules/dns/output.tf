output "domain_name" {
  description = "The domain name for the DNS zone"
  value       = azurerm_dns_zone.this.name
}

output "dns_rg_name" {
  description = "The name of the resource group"
  value       = module.rg.name
}

output "azure_name_servers" {
  description = "NS records to configure at your domain registrar"
  value       = azurerm_dns_zone.this.name_servers
}