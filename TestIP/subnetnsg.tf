resource "azurerm_network_security_group" "subnetnsg" {
  name                = "${var.prefix}_${local.loc}_${var.provisioner}_subnetnsg${random_integer.priority.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                                       = "SSH"
    priority                                   = 1001
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    destination_application_security_group_ids = [azurerm_application_security_group.asg.id]
    source_address_prefix                      = "${var.ssh_ip}/32"
  }

  security_rule {
    name                                       = "Web"
    priority                                   = 1002
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "80"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.asg.id]
  }

  security_rule {
    name                                       = "Ping"
    priority                                   = 1003
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Icmp"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.asg.id]
  }

  security_rule {
    name                                       = "Https"
    priority                                   = 1004
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "443"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.asg.id]
  }


  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_connect" {
  subnet_id                 = azurerm_subnet.vnetsubnet.id
  network_security_group_id = azurerm_network_security_group.subnetnsg.id
}