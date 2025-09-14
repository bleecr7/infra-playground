variable "domain_name" {
  description = "The domain name for the DNS zone."
  type        = string
  default     = "azure.brandonlee.cloud"
}

variable "infra_type" {
  description = "The name of the resource group to create."
  type        = string
  default     = "dns-zone"
}

variable "rg_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "uksouth"
}