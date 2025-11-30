resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.infra_type}-nic-${count.index}"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_ids != null ? var.public_ip_ids[count.index] : null
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  count                 = var.vm_count
  name                  = "${var.infra_type}-vm-${count.index}"
  location              = var.rg_location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = var.vm_size

  admin_username                  = "azureuser"
  admin_password                  = var.admin_password != null ? var.admin_password : null
  disable_password_authentication = false

  admin_ssh_key {
    username = "azureuser"
    public_key = var.admin_ssh_key
  }

  os_disk {
    name                 = "${var.infra_type}OSDisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.source_image.publisher
    offer     = var.source_image.offer
    sku       = var.source_image.sku
    version   = var.source_image.version
  }

  license_type = var.license_type

  priority   = var.vm_priority
  eviction_policy = var.vm_priority == "Spot" ? var.eviction_policy : null

  identity {
    type         = var.vm_identity_type == null ? null : var.vm_identity_type
    identity_ids = (var.vm_identity_type != null) && (var.vm_identity_id != null) ? [var.vm_identity_id] : null
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account.primary_blob_endpoint
  }

  provision_vm_agent = true
}



