data "azurerm_client_config" "current" {}

locals {
  environment         = var.environment
  sql_server_username = "hvhearingsapiadmin"
}

resource "azurerm_user_assigned_identity" "sqluser" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name = "${var.resource_prefix}-${local.environment}-sqluser"
  tags = var.tags
}
data "azuread_group" "directory_readers" {
  display_name     = "DTS Directory Readers"
  security_enabled = true
}
resource "azuread_group_member" "directory_readers" {
  group_object_id  = data.azuread_group.directory_readers.id
  member_object_id = azurerm_user_assigned_identity.sqluser.principal_id
}

resource "random_password" "sqlpass" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_mssql_server" "vh-infra-core" {
  name                         = "${var.resource_prefix}-${local.environment}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = local.sql_server_username
  administrator_login_password = random_password.sqlpass.result

  azuread_administrator {
    login_username              = "DTS Bootstrap (sub:dts-sharedservices-${local.environment})"
    object_id                   = data.azurerm_client_config.current.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = false
  }
  primary_user_assigned_identity_id = azurerm_user_assigned_identity.sqluser.id

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.sqluser.id
    ]
  }

  tags = merge({ displayName = "Virtual Courtroom SQL Server" }, var.tags)
}

# From TFSec
resource "azurerm_mssql_server_extended_auditing_policy" "vh-infra-core-sec-pol" {
  server_id = azurerm_mssql_server.vh-infra-core.id
}

resource "azurerm_template_deployment" "sqlbackup" {
  count = terraform.workspace == "Prod" ? 1 : 0

  name                = "db-backup"
  resource_group_name = var.resource_group_name

  template_body = file("${path.module}/sql_rentention.json")

  parameters = {
    databaseServerName = azurerm_mssql_server.vh-infra-core.name
    database           = join(",", keys(var.databases))
  }

  deployment_mode = "Incremental"
}

resource "azurerm_sql_database" "vh-infra-core" {
  for_each = var.databases

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_mssql_server.vh-infra-core.name

  edition                          = each.value.edition
  collation                        = each.value.collation
  requested_service_objective_name = each.value.performance_level

  tags = var.tags
}

module "db_secrets" {
  source         = "../KeyVaults/Secrets"
  key_vault_id   = var.key_vault_id
  key_vault_name = var.keyvault_name

  tags = var.tags
  secrets = [
    {
      name         = "db-admin-username"
      value        = local.sql_server_username
      tags         = var.tags
      content_type = ""
    },
    {
      name         = "db-admin-password"
      value        = random_password.sqlpass.result
      tags         = var.tags
      content_type = ""
    }
  ]

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

  name         = each.key
  namespace_id = azurerm_servicebus_namespace.vh-infra-core.id
  #namespace_name      = azurerm_servicebus_namespace.vh-infra-core.name

  enable_partitioning   = false
  lock_duration         = "PT5M"
  max_size_in_megabytes = 1024
}

data "azurerm_user_assigned_identity" "keda_mi" {
  count               = local.environment == "dev" ? 0 : 1
  name                = "keda-${local.environment}-mi"
  resource_group_name = "managed-identities-${local.environment}-rg"
}

resource "azurerm_role_assignment" "Azure_Service_Bus_Data_Receiver" {
  scope                = azurerm_servicebus_namespace.vh-infra-core.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = local.environment == "dev" ? "8e65726d-ee0f-46e7-9105-f97ab9f5e70b" : data.azurerm_user_assigned_identity.keda_mi[0].principal_id
}