# variable "networks" {
#   type    = list(any)
#   default = ["10.1.0.0", "10.2.0.0", "10.3.0.0"]
# }

# variable "vnetmask" {
#   default = 16
# }
# resource "random_integer" "randomint" {
#   min = 1
#   max = 10
# }

# variable "subnetmask" {
#   type    = list(any)
#   default = ["24"]
# }

# resource "azurerm_network_security_group" "subnetnsg10" {
#   count               = 1
#   name                = "${var.prefix}_${local.loc}_${var.provisioner}_subnetnsg${count.index + 1}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     destination_address_prefix = "*"
#     source_address_prefix      = "${var.ssh_ip}/32"
#   }
#   tags = var.tags
# }

# locals {
#   count = length(var.networks)
# }

# resource "azurerm_virtual_network" "vnet10" {
#   count               = local.count
#   name                = "${var.prefix}_${local.loc}_${var.provisioner}_vnet${count.index + 1}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   address_space       = ["${var.networks[count.index]}/${var.vnetmask}"]
#   tags                = var.tags
# }

# resource "azurerm_subnet" "vnetsubnet10" {
#   count                = local.count
#   name                 = "subnet${count.index + 1}"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet10[count.index].name
#   address_prefixes     = ["${var.networks[count.index]}/${var.subnetmask[0]}"]
# }

# resource "azurerm_subnet_network_security_group_association" "net_nsg_connect10" {
#   count                     = local.count
#   subnet_id                 = azurerm_subnet.vnetsubnet10[count.index].id
#   network_security_group_id = azurerm_network_security_group.subnetnsg10[0].id
# }
