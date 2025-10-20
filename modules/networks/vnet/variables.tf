variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "rg_name" {
  description = "The name of the resource group to create."
  type        = string
}

variable "rg_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "uksouth"
}

variable "infra_type" {
  description = "The type of infrastructure being deployed, used to name resources."
  type        = string
  default     = "network"
}

variable "resource_name" {
  description = "The name of the VNet"
  type = string
  default = null
}