resource "azurerm_monitor_diagnostic_setting" "example" {
name                           = "example"
target_resource_id             = "/subscriptions/xxxx"

log_analytics_workspace_id     = azurerm_log_analytics_workspace.this.id
log_analytics_destination_type = "Dedicated" # or null see [documentation][1]

  log {
      category = "Administrative"

      retention_policy {
      enabled = false
    }
  }
}