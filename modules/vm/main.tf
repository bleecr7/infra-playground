resource "azurerm_network_interface" "nic" {
  count               = var.count
  name                = "${var.name_prefix}-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  count                           = var.count
  name                            = "${var.name_prefix}-vm-${count.index}"
  location                        = var.location
  resource_group_name             = var.rg_name
  size                            = var.vm_size
  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_sku
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
