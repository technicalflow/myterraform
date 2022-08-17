resource "azurerm_application_security_group" "asg" {
  name                = "${var.prefix}_${local.loc}_${var.provisioner}_asg${random_integer.priority.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags = var.tags
}