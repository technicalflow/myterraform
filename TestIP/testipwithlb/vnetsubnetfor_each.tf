variable "subnetname" {
  description = "Map of Azure VNET subnet configuration"
  type        = map(any)
  default = {
    app_subnet = {
      name                 = "app_subnet"
      resource_group_name  = "vCloud-lab.com"
      virtual_network_name = "vnet1"
      address_prefixes     = ["10.0.1.0/24"]
    },
    db_subnet = {
      name                 = "db_subnet"
      resource_group_name  = "vCloud-lab.com"
      virtual_network_name = "vnet1"
      address_prefixes     = ["10.0.2.0/24"]
    }
  }
}


resource "azurerm_virtual_network" "vnet10" {
  name                = "vnet1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnetname

  name                 = each.value["name"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = each.value["virtual_network_name"]
  address_prefixes     = each.value["address_prefixes"]
  depends_on           = [azurerm_virtual_network.vnet10]
}