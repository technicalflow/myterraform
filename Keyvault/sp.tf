
data "azurerm_subscriptions" "available" {
}

# output "available_subscriptions" {
#   value = data.azurerm_subscriptions.available.subscriptions
# }

output "first_available_subscription_display_name" {
  value = data.azurerm_subscriptions.available.subscriptions[0].display_name
}

data "azuread_client_config" "current" {}

resource "azuread_application" "aadapp" {
  display_name = "aadapp"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "sp1" {
  application_id               = azuread_application.aadapp.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# resource "random_password" "demo_sp_secret" {
#   length           = 30
#   special          = true
#   min_numeric      = 5
#   min_special      = 2
#   override_special = "-_%@?"
# }

# resource "azuread_application_password" "demo_sp_secret" {
#   application_object_id = azuread_application.aadapp.object_id
#   value                 = random_password.demo_sp_secret.result
#   end_date_relative     = "168h" # 7 days
# }

resource "azuread_service_principal_password" "sp1_pass" {
  service_principal_id = azuread_service_principal.sp1.object_id
#   end_date = "2024-01-01T01:00:00Z"
#   value = "jdfaisjfioasjfioajsoifasjed2i"
}

data "azuread_service_principal" "sp1data" {
    display_name = azuread_service_principal.sp1.display_name
    object_id = azuread_service_principal.sp1.object_id
}