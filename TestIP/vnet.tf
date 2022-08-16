resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}_${local.loc}_${var.provisioner}_vnet${random_integer.priority.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.10.10.0/24"]
  tags                = var.tags
}

resource "azurerm_subnet" "vnetsubnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.10.128/25"]
}