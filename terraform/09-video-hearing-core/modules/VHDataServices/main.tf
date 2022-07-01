data "azurerm_client_config" "current" {}

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

resource "azurerm_mssql_virtual_network_rule" "aks00vnetrule" {

  name      = "ss-${local.environment}-vnet-aks00"
  server_id = azurerm_mssql_server.vh-infra-core.id
  subnet_id = data.azurerm_subnet.aks00-subnet.id
}

resource "azurerm_mssql_virtual_network_rule" "aks01vnetrule" {

  name      = "ss-${local.environment}-vnet-aks01"
  server_id = azurerm_mssql_server.vh-infra-core.id
  subnet_id = data.azurerm_subnet.aks01-subnet.id
}


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
resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_client_config.current.tenant_id
  role_definition_name = "Directory Reader"
  principal_id         = azurerm_user_assigned_identity.sqluser.principal_id
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
    login_username              = azurerm_user_assigned_identity.sqluser.name
    object_id                   = data.azurerm_client_config.current.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = false
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.sqluser.principal_id
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
  source       = "../KeyVaults/Secrets"
  key_vault_id = var.key_vault_id

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
