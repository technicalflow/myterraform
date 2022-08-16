resource "azurerm_public_ip" "pip" {
  count               = var.enable_public_ip_address == true ? 1 : 0
  name                = "${var.prefix}_${local.loc}_${var.provisioner}_pip${random_integer.priority.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
  sku_tier            = "Regional"
  domain_name_label   = null
  tags                = var.tags
}