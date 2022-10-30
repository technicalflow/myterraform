# locals {
#   dbname_list = [for n in azurerm_mssql_database.mssqldb : n.name]
#   secret_map = { for name in local.dbname_list : "mssql-${lower(name)}-database-url" => {
#     value = "jdbc:sqlserver://${var.server_fqdn}:1433;database=${name}"
#   } }
# }

resource "azurerm_resource_group" "rg1" {
  name     = "msa-mssql-test2"
  location = "francecentral"
}

# resource "azurerm_storage_account" "sa" {
#   name                     = "examplesa"
#   resource_group_name      = azurerm_resource_group.rg1.name
#   location                 = azurerm_resource_group.rg1.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

resource "azurerm_mssql_server" "sqlserver1" {
  name                         = "msa-mssql-server2"
  resource_group_name          = azurerm_resource_group.rg1.name
  location                     = azurerm_resource_group.rg1.location
  version                      = "12.0"
  administrator_login          = "vsadmin"
  administrator_login_password = "dkpowqUIB01nnB"
}

resource "azurerm_mssql_firewall_rule" "name" {
  end_ip_address   = "0.0.0.0"
  name             = "rule1"
  server_id        = azurerm_mssql_server.sqlserver1.id
  start_ip_address = "0.0.0.0"
}

resource "azurerm_mssql_database" "mssqldb" {
  for_each                    = var.databases
  name                        = each.value.name
  server_id                   = azurerm_mssql_server.sqlserver1.id
  collation                   = lookup(each.value, "collation", var.collation)
  sku_name                    = lookup(each.value, "sku_name", var.sku_name)
  max_size_gb                 = lookup(each.value, "max_size_gb", var.max_size_gb)
  min_capacity                = lookup(each.value, "min_capacity", var.min_capacity)
  auto_pause_delay_in_minutes = lookup(each.value, "auto_pause_delay", var.autopause_delay)
  create_mode                 = lookup(each.value, "create_mode", var.create_mode)
  creation_source_database_id = lookup(each.value, "creation_source_database_id", var.creation_source_database_id)
  storage_account_type        = var.storage_account_type
  tags                        = var.tags

  transparent_data_encryption_enabled = true // transparent data encryption can only be disabled on Data Warehouse SKUs
  threat_detection_policy {
    state                      = var.state
    disabled_alerts            = var.disabled_alerts
    email_account_admins       = var.email_account_admins
    email_addresses            = var.email_addresses
    retention_days             = var.td_retention_days
    storage_account_access_key = var.state == "Enabled" ? var.storage_account_access_key : null
    storage_endpoint           = var.state == "Enabled" ? var.storage_endpoint : null
  }
  
  restore_point_in_time          = var.create_mode == "PointInTimeRestore" ? var.restore_point_in_time : null
  restore_dropped_database_id    = var.create_mode == "Restore" ? var.restore_dropped_database_id : null
  recover_database_id            = var.recover_database_id
  read_scale                     = var.sku_name == "Basic" ? null : var.read_scale
  read_replica_count             = var.read_replica_count
  sample_name                    = var.sample_name
  maintenance_configuration_name = var.maintenance_configuration_name
  ledger_enabled                 = var.ledger_enabled
  license_type                   = var.license_type
  geo_backup_enabled             = var.geo_backup_enabled
  elastic_pool_id                = var.elastic_pool_id
  zone_redundant                 = var.zone_redundant

  ### Backup Retention policy
  short_term_retention_policy {
    retention_days           = lookup(each.value, "retention_days", var.str_retention_days)
    backup_interval_in_hours = var.str_backup_interval_in_hours
  }

  long_term_retention_policy {
    monthly_retention = var.autopause_delay == -1 ? var.ltr_policy_monthly : "PT0S"
    week_of_year      = var.autopause_delay == -1 ? var.ltr_policy_week_of_year : null
    weekly_retention  = var.autopause_delay == -1 ? var.ltr_policy_weekly : "PT0S"
    yearly_retention  = var.autopause_delay == -1 ? var.ltr_policy_yearly : "PT0S"
  }

  # lifecycle {
  #   ignore_changes = [
  #     sku_name,
  #   ]
  # }
}

# resource "azurerm_mssql_database_vulnerability_assessment_rule_baseline" "name" {
#   database_name = "value"
#   rule_id = "value"
#   server_vulnerability_assessment_id = "value"
#   baseline_name = "value"
#   baseline_result {
#     result = [ "value" ]
#   }
# }

# resource "azurerm_mssql_database_extended_auditing_policy" "name" {
#   database_id = "value"
#   log_monitoring_enabled = 
#   storage_account_access_key = 
#   storage_account_access_key_is_secondary = 
#   retention_in_days = azurerm_mssql_database.this
#   storage_endpoint = 
#   enabled = 
# }

