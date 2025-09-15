variable "domain_name" {
  description = "The domain name for the DNS zone."
  type        = string
  default     = "azure.brandonlee.cloud"
}

variable "rg_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "uksouth"
}

variable "infra_type" {
  description = "The type of infrastructure to deploy (e.g., 'web', 'app', 'db')."
  type        = string
}

variable "iaas_vnet_address_space" {
  description = "The address space for the IaaS virtual network."
  type        = list(string)
}

variable "iaas_subnets_map" {
  description = "A map of subnets for each virtual network."
  type        = map(list(string))

}