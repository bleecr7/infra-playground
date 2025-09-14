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

resource "azurerm_windows_virtual_machine" "this" {
  count                 = var.vm_count
  name                  = "${var.infra_type}-vm-${count.index}"
  admin_username        = "azureuser"
  admin_password        = var.admin_password
  location              = var.rg_location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "webOSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.source_image.publisher
    offer     = var.source_image.offer
    sku       = var.source_image.sku
    version   = var.source_image.version
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account.primary_blob_endpoint
  }

  provision_vm_agent = true
}



