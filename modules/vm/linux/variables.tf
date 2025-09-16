variable "infra_type" {
  description = "The type of infrastructure being deployed, used to name resources."
  type        = string
  default     = "IaaS"
}

variable "vm_count" {
  description = "The number of virtual machines to create."
  type        = number
  default     = 1
  validation {
    condition     = var.vm_count > 0
    error_message = "The number of virtual machines must be greater than zero."
  }
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_DS1_v2"
  validation {
    condition     = contains(["Standard_B1s", "Standard_B2s", "Standard_DS1_v2", "Standard_DS2_v2"], var.vm_size)
    error_message = "The VM size must be one of: Standard_B1s, Standard_B2s, Standard_DS1_v2, Standard_DS2_v2."
  }
}

variable "vm_priority" {
  description = "The priority of the virtual machine."
  type        = string
  default     = "Spot"
  validation {
    condition     = contains(["Regular", "Low", "Spot"], var.vm_priority)
    error_message = "The VM priority must be either 'Regular', 'Low', or 'Spot'."
  }
}

variable "eviction_policy" {
  description = "The eviction policy for Spot VMs."
  type        = string
  default     = "Deallocate"
  validation {
    condition     = contains(["Deallocate", "Delete"], var.eviction_policy) && var.vm_priority == "Spot" || var.vm_priority != "Spot"
    error_message = "The eviction policy must be either 'Deallocate' or 'Delete'."
  }
}

variable "rg_location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "uksouth"
}

variable "rg_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string
  validation {
    condition     = length(var.rg_name) > 0
    error_message = "The resource group name must not be empty."
  }
}

variable "source_image" {
  description = "The source image reference for the virtual machine."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "almalinux"
    offer     = "almalinux-x86_64"
    sku       = "9-gen2"
    version   = "latest"
  }
}

variable "admin_password" {
  description = "The administrator password for the virtual machine."
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "The ID of the subnet where the network interface will be created."
  type        = string
  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "The subnet ID must not be empty."
  }
}

variable "public_ip_ids" {
  description = "A list of public IP IDs to associate with the network interfaces. If null, no public IPs will be associated."
  type        = list(string)
  default     = null
  validation {
    condition     = var.public_ip_ids == null || length(var.public_ip_ids) == var.vm_count
    error_message = "The length of public_ip_ids must be equal to vm_count or null."
  }
}

variable "storage_account" {
  description = "The storage account URI for boot diagnostics."
  type        = any
  validation {
    condition     = length(var.storage_account) > 0
    error_message = "The storage account URI must not be empty."
  }
}
