# variable "server_id" {
#   type        = string
#   description = "Id of SQL server"
# }

variable "server_fqdn" {
  type        = string
  description = "FQDN of Azure SQL Server"
  default     = "null"
}

variable "tags" {
  type        = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "collation" {
  type        = string
  description = "(Optional) Specifies the collation of the database. Changing this forces a new resource to be created."
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sku_name" {
  type        = string
  description = "(Optional) Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will force a new resource to be created."
  default     = "GP_S_Gen5_1"
}

variable "max_size_gb" {
  type        = string
  description = "(Optional) The max size of the database in gigabytes."
  default     = "20"
}

variable "min_capacity" {
  type        = string
  description = " (Optional) Minimal capacity that database will always have allocated, if not paused. This property is only settable for General Purpose Serverless databases"
  default     = "0.5"
}

variable "autopause_delay" {
  type        = number
  description = "(Optional) Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for General Purpose Serverless databases"
  default     = 60
}

variable "str_retention_days" {
  type        = number
  description = " (Optional) Specifies the number of days to keep in the Threat Detection audit logs."
  default     = 7
}

variable "str_backup_interval_in_hours" {
  type    = number
  default = 12
}

variable "create_mode" {
  type        = string
  description = " (Optional) The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary."
  default     = "Default"
}

variable "creation_source_database_id" {
  type        = string
  description = "(Optional) The ID of the source database from which to create the new database. This should only be used for databases with create_mode values that use another database as reference"
  default     = null
}

variable "storage_account_type" {
  type        = string
  description = "(Optional) Specifies the storage account type used to store backups for this database. Possible values are Geo, Local and Zone. The default value is Geo"
  default     = "Local"
}

variable "elastic_pool_id" {
  type        = string
  default     = null
  description = "(Optional) Specifies the ID of the elastic pool containing this database."
}

variable "geo_backup_enabled" {
  type        = bool
  default     = true
  description = "(Optional) A boolean that specifies if the Geo Backup Policy is enabled. It is only applicable for DataWarehouse SKUs"
}

variable "zone_redundant" {
  type        = bool
  default     = false
  description = " (Optional) Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
}

variable "maintenance_configuration_name" {
  type        = string
  default     = "SQL_Default"
  description = "(Optional) The name of the Public Maintenance Configuration window to apply to the database. Valid values include SQL_Default, SQL_EastUS_DB_1, SQL_EastUS2_DB_1, SQL_SoutheastAsia_DB_1, SQL_AustraliaEast_DB_1, SQL_NorthEurope_DB_1, SQL_SouthCentralUS_DB_1, SQL_WestUS2_DB_1, SQL_UKSouth_DB_1, SQL_WestEurope_DB_1, SQL_EastUS_DB_2, SQL_EastUS2_DB_2, SQL_WestUS2_DB_2, SQL_SoutheastAsia_DB_2, SQL_AustraliaEast_DB_2, SQL_NorthEurope_DB_2, SQL_SouthCentralUS_DB_2, SQL_UKSouth_DB_2, SQL_WestEurope_DB_2, SQL_AustraliaSoutheast_DB_1, SQL_BrazilSouth_DB_1, SQL_CanadaCentral_DB_1, SQL_CanadaEast_DB_1, SQL_CentralUS_DB_1, SQL_EastAsia_DB_1, SQL_FranceCentral_DB_1, SQL_GermanyWestCentral_DB_1, SQL_CentralIndia_DB_1, SQL_SouthIndia_DB_1, SQL_JapanEast_DB_1, SQL_JapanWest_DB_1, SQL_NorthCentralUS_DB_1, SQL_UKWest_DB_1, SQL_WestUS_DB_1, SQL_AustraliaSoutheast_DB_2, SQL_BrazilSouth_DB_2, SQL_CanadaCentral_DB_2, SQL_CanadaEast_DB_2, SQL_CentralUS_DB_2, SQL_EastAsia_DB_2, SQL_FranceCentral_DB_2, SQL_GermanyWestCentral_DB_2, SQL_CentralIndia_DB_2, SQL_SouthIndia_DB_2, SQL_JapanEast_DB_2, SQL_JapanWest_DB_2, SQL_NorthCentralUS_DB_2, SQL_UKWest_DB_2, SQL_WestUS_DB_2, SQL_WestCentralUS_DB_1, SQL_FranceSouth_DB_1, SQL_WestCentralUS_DB_2, SQL_FranceSouth_DB_2, SQL_SwitzerlandNorth_DB_1, SQL_SwitzerlandNorth_DB_2, SQL_BrazilSoutheast_DB_1, SQL_UAENorth_DB_1, SQL_BrazilSoutheast_DB_2, SQL_UAENorth_DB_2. Defaults to SQL_Default.  Only applicable if elastic_pool_id is not set."
}

variable "license_type" {
  type        = string
  default     = null
  description = "(Optional) Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice"
}

variable "ledger_enabled" {
  type        = bool
  default     = false
  description = "(Optional) A boolean that specifies if this is a ledger database. Defaults to false. Changing this forces a new resource to be created. Enabling ledger functionality will make all tables in your database ledger tables that can be updated. This option cannot be changed after you create your database"
}

variable "recover_database_id" {
  type        = string
  default     = null
  description = " (Optional) The ID of the database to be recovered. This property is only applicable when the create_mode is Recovery"
}

variable "read_scale" {
  type        = string
  default     = null
  description = "(Optional) If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases."
}

variable "sample_name" {
  type        = string
  default     = null
  description = "(Optional) Specifies the name of the sample schema to apply when creating this database."
}

variable "read_replica_count" {
  type        = number
  default     = 0
  description = " (Optional) The number of readonly secondary replicas associated with the database to which readonly application intent connections may be routed. This property is only settable for Hyperscale edition databases."
}

variable "restore_dropped_database_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the database to be restored. This property is only applicable when the create_mode is Restore."
}

variable "restore_point_in_time" {
  type        = string
  default     = null
  description = " (Required) Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. This property is only settable for create_mode= PointInTimeRestore databases."
}

variable "state" {
  type        = string
  default     = "New"
  description = " (Required) The State of the Policy. Possible values are Enabled, Disabled or New"
}

variable "disabled_alerts" {
  type        = set(string)
  default     = null
  description = " (Optional) Specifies a list of alerts which should be disabled. Possible values include Access_Anomaly, Sql_Injection and Sql_Injection_Vulnerability"
}

variable "email_account_admins" {
  type        = string
  default     = null
  description = " (Optional) Should the account administrators be emailed when this alert is triggered?"
}

variable "email_addresses" {
  type        = list(any)
  default     = null
  description = " (Optional) A list of email addresses which alerts should be sent to"
}

variable "td_retention_days" {
  type        = number
  default     = 0
  description = "(Optional) Specifies the number of days to keep in the Threat Detection audit logs"
}

variable "storage_account_access_key" {
  type        = string
  default     = null
  description = "(Optional) Specifies the identifier key of the Threat Detection audit storage account. Required if state is Enabled"
}

variable "storage_endpoint" {
  type        = string
  default     = null
  description = "(Optional) Specifies the blob storage endpoint (e.g. https://example.blob.core.windows.net). This blob storage will hold all Threat Detection audit logs. Required if state is Enabled"
}

variable "ltr_policy_monthly" {
  type    = string
  default = "P1M"
}

variable "ltr_policy_week_of_year" {
  type    = number
  default = 10
}

variable "ltr_policy_weekly" {
  type    = string
  default = "P1W"
}

variable "ltr_policy_yearly" {
  type    = string
  default = "P12M"
}

variable "databases" {
  type        = map(map(string))
  description = "Map of databases"
  default = {
    database = {
      name = "db100"
    }
    # database1 = {
    #   name = "db200"
    # }
  }
}
