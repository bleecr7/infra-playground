variable "rg_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "uksouth"
}

variable "infra_type" {
  description = "The type of infrastructure being deployed, used to name resources."
  type        = string
  default     = "IaaS"
}