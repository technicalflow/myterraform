# resource "azurerm_resource_group" "rg1" {
#   name     = "msa-mssql-test1"
#   location = "francecentral"
# }

# # resource "azurerm_storage_account" "sa" {
# #   name                     = "examplesa"
# #   resource_group_name      = azurerm_resource_group.rg1.name
# #   location                 = azurerm_resource_group.rg1.location
# #   account_tier             = "Standard"
# #   account_replication_type = "LRS"
# # }

# resource "azurerm_mssql_server" "mssqlserver" {
#   name                         = "msa-mssql-server"
#   resource_group_name          = azurerm_resource_group.rg1.name
#   location                     = azurerm_resource_group.rg1.location
#   version                      = "12.0"
#   administrator_login          = "vsadmin"
#   administrator_login_password = "dkpowqUIB01nnB"
# }

# resource "azurerm_mssql_database" "mssqldb" {
#   name           = "msa-mssql-db"
#   server_id      = azurerm_mssql_server.mssqlserver.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"

#   # max_size_gb    = 4
#   # read_scale     = true //if basic - no 
#   sku_name       = "Basic"
#   zone_redundant = false

# }

# # resource "azurerm_mssql_firewall_rule" "name" {
# #   end_ip_address = "value"
# #   name = "value"
# #   server_id = "value"
# #   start_ip_address = "value"

# # }

# resource "azurerm_mssql_firewall_rule" "name" {
#   end_ip_address = "0.0.0.0"
#   name = "rule1"
#   server_id = azurerm_mssql_server.mssqlserver.id
#   start_ip_address = "0.0.0.0"

# }