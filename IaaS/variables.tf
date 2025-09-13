variable "infra_type" {
  description = "The type of infrastructure being deployed, used to name resources."
  type        = string
  default     = "IaaS"
}

variable "rg_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "uksouth"
}

variable "admin_password" {
  description = "The administrator password for the virtual machine."
  type        = string
  sensitive   = true
}

variable "windows_vm_count" {
  description = "The number of Windows virtual machines to create."
  type        = number
  #   validation {
  #     condition     =  var.windows_vm_count > 0
  #     error_message = "The number of Windows virtual machines must be greater than zero."
  #   }
}

variable "unix_vm_count" {
  description = "The number of Unix virtual machines to create."
  type        = number
  default     = 0
}
