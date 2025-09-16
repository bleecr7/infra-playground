variable "infra_type" {
  description = "Type of infrastructure, used for naming resources."
  type        = string
  default     = "bastion"
}

variable "rg_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "uksouth"
}

variable "bastion_subnet_prefix" {
  description = "The subnet prefix for the bastion subnet."
  type        = list(string)
  default     = ["10.10.0.0/27"]
}
