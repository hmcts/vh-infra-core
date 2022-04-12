data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "aks00-subnet" {
  name                 = "aks-00"
  virtual_network_name = "ss-${local.environment}-vnet"
  resource_group_name  = "ss-${local.environment}-network-rg"
}

data "azurerm_subnet" "aks01-subnet" {
  name                 = "aks-01"
  virtual_network_name = "ss-${local.environment}-vnet"
  resource_group_name  = "ss-${local.environment}-network-rg"
}

resource "azurerm_sql_virtual_network_rule" "aks00vnetrule" {

  name                = "ss-${local.environment}-vnet-aks00"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.vh-infra-core.name
  subnet_id           = data.azurerm_subnet.aks00-subnet.id
}

resource "azurerm_sql_virtual_network_rule" "aks01vnetrule" {

  name                = "ss-${local.environment}-vnet-aks01"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.vh-infra-core.name
  subnet_id           = data.azurerm_subnet.aks01-subnet.id
}


locals {
  environment = var.environment
}

resource "azurerm_user_assigned_identity" "sqluser" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name = "${var.resource_prefix}-${local.environment}-sqluser"
  tags = var.tags
}

resource "random_password" "sqlpass" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_sql_server" "vh-infra-core" {
  name                         = "${var.resource_prefix}-${local.environment}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "hvhearingsapiadmin"
  administrator_login_password = random_password.sqlpass.result

  tags = merge({ displayName = "Virtual Courtroom SQL Server" }, var.tags)
}

# From TFSec
resource "azurerm_mssql_server_extended_auditing_policy" "vh-infra-core-sec-pol" {
  server_id = azurerm_sql_server.vh-infra-core.id
}

resource "azurerm_template_deployment" "sqlbackup" {
  count = terraform.workspace == "Prod" ? 1 : 0

  name                = "db-backup"
  resource_group_name = var.resource_group_name

  template_body = file("${path.module}/sql_rentention.json")

  parameters = {
    databaseServerName = azurerm_sql_server.vh-infra-core.name
    database           = join(",", keys(var.databases))
  }

  deployment_mode = "Incremental"
}

resource "azurerm_sql_active_directory_administrator" "sqluser" {
  server_name         = azurerm_sql_server.vh-infra-core.name
  resource_group_name = var.resource_group_name

  login     = azurerm_user_assigned_identity.sqluser.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.sqluser.principal_id

}

resource "azurerm_key_vault_secret" "hvhearingsapiadmin" {
  name         = "hvhearingsapiadmin"
  value        = random_password.sqlpass.result
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "VhBookingsDatabaseConnectionString" {
  name         = "connectionstrings--VhBookings"
  value        = "Server=tcp:${azurerm_sql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhbookings;Persist Security Info=False;User ID=${azurerm_sql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "VhVideoDatabaseConnectionString" {
  name         = "connectionstrings--vhvideo"
  value        = "Server=tcp:${azurerm_sql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhvideo;Persist Security Info=False;User ID=${azurerm_sql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "VhNotificationDatabaseConnectionString" {
  name         = "connectionstrings--vhnotificationsapi"
  value        = "Server=tcp:${azurerm_sql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhnotification;Persist Security Info=False;User ID=${azurerm_sql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "VhTestApiDatabaseConnectionString" {
  name         = "connectionstrings--testapi"
  value        = "Server=tcp:${azurerm_sql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhtestapi;Persist Security Info=False;User ID=${azurerm_sql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}

resource "azurerm_sql_database" "vh-infra-core" {
  for_each = var.databases

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.vh-infra-core.name

  edition                          = each.value.edition
  collation                        = each.value.collation
  requested_service_objective_name = each.value.performance_level

  tags = var.tags
}

resource "azurerm_servicebus_namespace" "vh-infra-core" {
  name                = "${var.resource_prefix}-${local.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_servicebus_queue" "vh-infra-core" {
  for_each = var.queues

  name                = each.key
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.vh-infra-core.name

  enable_partitioning   = false
  lock_duration         = "PT5M"
  max_size_in_megabytes = 1024
}


resource "azurerm_key_vault_secret" "servicebusqueue_connectionstring" {
  name         = "servicebusqueue--connectionstring"
  value        = azurerm_servicebus_namespace.vh-infra-core.default_primary_connection_string
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "connectionstrings--videoapi" {
  name         = "connectionstrings--videoapi"
  value        = "Server=tcp:${azurerm_sql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhvideo;Persist Security Info=False;User ID=${azurerm_sql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}

