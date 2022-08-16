resource "azurerm_network_interface" "nic" {
  name                          = "${var.prefix}_${local.loc}_${var.provisioner}_nic${random_integer.priority.result}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  count                         = var.number_of_nics
  enable_accelerated_networking = false
  tags                          = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vnetsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[0].id
  }

  depends_on = [
    azurerm_public_ip.pip,
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}_${local.loc}_${var.provisioner}_vm${random_integer.priority.result}"
  computer_name       = "${var.prefix}${local.loc}${var.provisioner}vm${random_integer.priority.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  tags                = var.tags
  custom_data         = base64encode(file("./script.sh"))

  admin_username                  = var.admin_username
  admin_password                  = var.disable_password_authentication != true && var.admin_password == null ? random_password.password[0].result : var.admin_password
  disable_password_authentication = var.disable_password_authentication

  network_interface_ids = [
    azurerm_network_interface.nic[0].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standardssd_LRS"
    disk_size_gb         = 30
    name                 = "${var.prefix}_${local.loc}_${var.provisioner}_vm_osdisk${random_integer.priority.result}"
  }

  source_image_reference {
    publisher = "oracle"
    offer     = "oracle-linux"
    sku       = "ol86-lvm"
    version   = "latest"
  }

  # source_image_reference {
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "18.04.0-LTS"
  #   version   = "latest"
  # }
  
  boot_diagnostics {
  }

  depends_on = [
    azurerm_public_ip.pip,
    azurerm_virtual_network.vnet
  ]
}