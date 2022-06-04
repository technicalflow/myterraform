data "azurerm_client_config" "name" {
  
}
resource "azurerm_role_assignment" "acr" {
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_resource_group.default.name}/providers/Microsoft.Web/serverFarms/${azurerm_service_plan.defaultsp.name}"
  role_definition_name = "Reader"
  # principal_id         = azurerm_app_service.default.identity[1].principal_id
  principal_id = data.azurerm_client_config.name.object_id
  depends_on = [
    azurerm_service_plan.defaultsp
  ]
}

