locals {
  environment = var.environment
}

data "azurerm_client_config" "current" {}

#### Per App Key Vault

#tfsec:ignore:azure-keyvault-no-purge
#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "app_keyvaults" {
  for_each = var.keyvaults

  name                        = "${each.key}-${var.environment}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
  tags     = var.tags


}

resource "azurerm_key_vault_access_policy" "app_access_policy" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "52432a41-19d7-4372-b9d8-5703f0b4fc2d"

  certificate_permissions = [
    "backup",
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "restore",
    "setissuers",
    "update"
  ]

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]
}

resource "azurerm_key_vault_access_policy" "app_access_policy1" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "4c5243b4-5106-4d45-8635-7c9b6ca5ab6c"

  certificate_permissions = [
    "backup",
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "restore",
    "setissuers",
    "update"
  ]

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]
}

resource "azurerm_key_vault_access_policy" "user_identity" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.kvuser.principal_id

  certificate_permissions = [
    "get",
  ]

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
    "list",
    "set"
  ]
}

resource "azurerm_key_vault_access_policy" "dts_operations" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "backup",
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "restore",
    "setissuers",
    "update"
  ]

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]
}

#tfsec:ignore:azure-keyvault-no-purge
#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "vh-infra-core-ht" {
  name                        = var.resource_group_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment      = true

  sku_name = "standard"
  tags     = var.tags

}

resource "azurerm_key_vault_access_policy" "devops" {

  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "52432a41-19d7-4372-b9d8-5703f0b4fc2d"

  certificate_permissions = [
    "backup",
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "restore",
    "setissuers",
    "update"
  ]

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]

}

resource "azurerm_key_vault_access_policy" "devops1" {

  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "4c5243b4-5106-4d45-8635-7c9b6ca5ab6c"

  certificate_permissions = [
    "backup",
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "restore",
    "setissuers",
    "update"
  ]

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]

}


resource "azurerm_key_vault_access_policy" "sp_access_policy" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "ae3963c5-b695-42c9-aa24-1d32617f51d5"

  certificate_permissions = [
    "backup",
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "restore",
    "setissuers",
    "update"
  ]

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]
}

# kv user identity
resource "azurerm_key_vault_access_policy" "kv_user_identity" {

  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.kvuser.principal_id

  certificate_permissions = [
    "get",
  ]

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
    "list",
    "set"
  ]
}

resource "azurerm_key_vault_access_policy" "azkvap" {

  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "backup",
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "restore",
    "setissuers",
    "update"
  ]

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]
}

data "azurerm_resource_group" "managed-identities-rg" {
  name = "managed-identities-${local.environment}-rg"
}

resource "azurerm_user_assigned_identity" "kvuser" {
  resource_group_name = data.azurerm_resource_group.managed-identities-rg.name
  location            = data.azurerm_resource_group.managed-identities-rg.location

  name = "${var.resource_prefix}-${local.environment}-kvuser"
  tags = var.tags
}

resource "azurerm_role_assignment" "Reader" {
  principal_id         = azurerm_user_assigned_identity.kvuser.principal_id
  role_definition_name = "Reader"
  scope                = azurerm_key_vault.vh-infra-core-ht.id
}

resource "azurerm_role_assignment" "App-Reader" {
  for_each             = azurerm_key_vault.app_keyvaults
  principal_id         = azurerm_user_assigned_identity.kvuser.principal_id
  role_definition_name = "Reader"
  scope                = each.value.id
}

resource "azurerm_key_vault_secret" "external-secrets" {
  for_each = var.external_passwords

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}
