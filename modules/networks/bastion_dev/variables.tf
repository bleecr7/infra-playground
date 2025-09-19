variable "rg_name" {
  description = "Azure resource group name in which to create the bastion host."
  type        = string
}

variable "rg_location" {
  description = "The Azure region where the resource group is located."
  type        = string
}

variable "vnet_name" {
  description = "The name of the VNet to deploy the Bastion host into."
  type        = string
}

variable "vnet_id" {
  description = "The VNet to deploy the Bastion host into."
  type        = string
}
