resource "azurerm_mariadb_server" "mdbs1" {
  name                = "${var.prefix}mdb2"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.current.name

  sku_name = "B_Gen5_2"

  storage_mb            = 5120
  backup_retention_days = 10
  #georedundancy needs higher sku
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = "10.2"
  ssl_enforcement_enabled      = true

}

resource "azurerm_mariadb_database" "example" {
  name                = "mariadb_database"
  resource_group_name = data.azurerm_resource_group.current.name
  server_name         = azurerm_mariadb_server.mdbs1.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}
