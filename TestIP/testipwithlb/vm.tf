resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}_${local.loc}_${var.provisioner}_vm${random_integer.priority.result}"
  computer_name       = "${var.prefix}${local.loc}${var.provisioner}vm${random_integer.priority.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.image_name == "ubuntu" ? var.vm_size[1] : var.vm_size[0]
  tags                = var.tags
  custom_data         = var.image_name == "ubuntu" ? base64encode(file("./scriptu.sh")) : base64encode(file("./script.sh"))

  admin_username                  = var.admin_username
  admin_password                  = var.disable_password_authentication != true && var.admin_password == null ? random_password.password[0].result : var.admin_password
  disable_password_authentication = var.disable_password_authentication

  network_interface_ids = [
    azurerm_network_interface.nic.id,
    azurerm_network_interface.nic2.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_key
  }

  os_disk {
    caching              = var.disk_caching
    storage_account_type = "${var.disk_type["Standard_SSD"]}_${var.redundancy[0]}"
    disk_size_gb         = 30
    name                 = "${var.prefix}_${local.loc}_${var.provisioner}_vm_osdisk${random_integer.priority.result}"
  }

  source_image_reference {
    publisher = var.image_list[lower(var.image_name)]["publisher"]
    offer     = var.image_list[lower(var.image_name)]["offer"]
    sku       = var.image_list[lower(var.image_name)]["sku"]
    version   = var.image_list[lower(var.image_name)]["version"]
  }

  boot_diagnostics {
  }

  depends_on = [
    azurerm_virtual_network.vnet10
  ]
  lifecycle {
    ignore_changes = [
      custom_data
    ]
  }
}