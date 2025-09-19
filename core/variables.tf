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

variable "iaas_deploy" {
  description = "Flag to indicate if IaaS resources should be deployed (1 for yes, 0 for no)."
  type        = number
}
variable "iaas_vnet_address_space" {
  description = "The address space for the IaaS virtual network."
  type        = list(string)
}

variable "iaas_subnets_map" {
  description = "A map of subnets for each virtual network."
  type        = map(list(string))

}

variable "paas_deploy" {
  description = "Flag to indicate if PaaS resources should be deployed (1 for yes, 0 for no)."
  type        = number
}

variable "tls_cert" {
  description = "The TLS certificate in PFX format, base64 encoded."
  type        = string
  sensitive   = true
}

variable "tls_cert_password" {
  description = "The password for the TLS certificate."
  type        = string
  sensitive   = true
}