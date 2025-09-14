variable "infra_type" {
  description = "The type of infrastructure being deployed, used to name resources."
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group where the NSG will be created."
  type        = string
}

variable "rg_location" {
  description = "The location of the resource group where the NSG will be created."
  type        = string
}

variable "security_rules" {
  description = "A list of security rules to be applied to the NSG."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}