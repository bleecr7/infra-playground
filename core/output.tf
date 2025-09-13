output "name_servers" {
  description = "NS records to configure at your domain registrar"
  value       = module.dns.azure_name_servers
}