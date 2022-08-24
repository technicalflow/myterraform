locals {
  security_rule = [{
    name     = "Web"
    priority = 1002
    protocol = "Tcp"
    port     = 80
    asg      = azurerm_application_security_group.asg.id
    },
    {
      name     = "Https"
      priority = 1004
      protocol = "Tcp"
      port     = 443
      asg      = azurerm_application_security_group.asg.id
      # },
      # {
      #     name     = "Ping"
      #     priority = 1003
      #     protocol = "Icmp"
      #     port     = 80
  }]
}

resource "azurerm_network_security_group" "nicnsg" {
  name                = "${var.prefix}_${local.loc}_${var.provisioner}_nicnsg${random_integer.priority.result}"
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
    source_address_prefix                      = var.ssh_ip != null ? "${var.ssh_ip}/32" : "*"
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

  dynamic "security_rule" {
    for_each = local.security_rule
    iterator = sg
    content {
      name                                       = sg.value.name
      priority                                   = sg.value.priority
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = lookup(sg.value, "protocol", "Tcp")
      source_port_range                          = "*"
      destination_port_range                     = sg.value.port
      source_address_prefix                      = "*"
      destination_application_security_group_ids = [sg.value.asg]
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_application_security_group.asg,
    azurerm_network_interface.nic
  ]
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic[0].id
  network_security_group_id = azurerm_network_security_group.nicnsg.id
}


resource "azurerm_network_interface_application_security_group_association" "nicasg" {
  network_interface_id          = azurerm_network_interface.nic[0].id
  application_security_group_id = azurerm_application_security_group.asg.id
}