data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv1" {
  name                       = "msafs-tf-keyvault"
  location                   = azurerm_resource_group.rg1.location
  resource_group_name        = azurerm_resource_group.rg1.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false # so we can fully delete it

  depends_on = [
      azurerm_resource_group.rg1,
  ]

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "list",
      "delete",
      "purge",
      "recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "secret1" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on = [
    azurerm_key_vault.kv1
  ]
}

data "azurerm_key_vault_secret" "secretread" {
  name         = azurerm_key_vault_secret.secret1.name
  key_vault_id = azurerm_key_vault.kv1.id
}

output "KV_Secret_is" {
  value = data.azurerm_key_vault_secret.secretread.value
  sensitive = true
}

# resource "azurerm_role_assignment" "test" {
#   scope                = "yourScope"   # the resource id
#   role_definition_name = "the Role In need" # such as "Contributor"
#   principal_id         = "your service principal id"
# }