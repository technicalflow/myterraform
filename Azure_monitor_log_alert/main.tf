resource "azurerm_resource_group" "rg1" {
  name     = "msanewrg1"
  location = "francecentral"
}

resource "azurerm_monitor_action_group" "main" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.rg1.name
  short_name          = "p0action"
  # email_receiver {
  #   name = email1
  #   email_address = var.email
  # }

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }
}


# resource "azurerm_monitor_alert_processing_rule_action_group" "name" {
  
# }

# resource "azurerm_monitor_alert_processing_rule_suppression" "name" {

# }
resource "azurerm_storage_account" "to_monitor" {
  name                     = "msanewsa1000"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.rg1.name
  scopes              = [azurerm_resource_group.rg1.id]
  description         = "This alert will monitor a specific storage account updates."


  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Storage/storageAccounts/write"
    category       = "Recommendation"
    }

  action {
    action_group_id = azurerm_monitor_action_group.main.id

    webhook_properties = {
      from = "terraform"
    }
  }
}