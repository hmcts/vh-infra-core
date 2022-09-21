
data "azurerm_client_config" "current" {}

#### Per App Key Vault

#tfsec:ignore:azure-keyvault-no-Purge
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
  sku_name                    = "standard"
  tags                        = var.tags
}

resource "azurerm_key_vault_access_policy" "app_access_policy" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "52432a41-19d7-4372-b9d8-5703f0b4fc2d"

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]

  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

resource "azurerm_key_vault_access_policy" "dts_sds_dev" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "7bde62e7-b39f-487c-95c9-b4c794fdbb96" # DTS SDS Developers AD Group

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]

  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

resource "azurerm_key_vault_access_policy" "app_access_policy1" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "4c5243b4-5106-4d45-8635-7c9b6ca5ab6c"

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]

  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

resource "azurerm_key_vault_access_policy" "user_identity" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.vh_mi_principal_id # vh-ENV-mi 

  certificate_permissions = [
    "Get",
  ]

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "dts_operations" {
  for_each = azurerm_key_vault.app_keyvaults

  key_vault_id = azurerm_key_vault.app_keyvaults[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]

  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

#tfsec:ignore:azure-keyvault-no-Purge
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

resource "azurerm_key_vault_access_policy" "dts_sds_dev_infrakv" {
  count = var.environment != "prod" ? 1 : 0

  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "7bde62e7-b39f-487c-95c9-b4c794fdbb96" # DTS SDS Developers AD Group

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]

  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

# kv user identity
resource "azurerm_key_vault_access_policy" "kv_user_identity" {

  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.vh_mi_principal_id

  certificate_permissions = [
    "Get",
  ]

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "azkvap" {

  key_vault_id = azurerm_key_vault.vh-infra-core-ht.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]

  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

resource "azurerm_role_assignment" "Reader" {
  principal_id         = var.vh_mi_principal_id
  role_definition_name = "Reader"
  scope                = azurerm_key_vault.vh-infra-core-ht.id
}

resource "azurerm_role_assignment" "App-Reader" {
  for_each             = azurerm_key_vault.app_keyvaults
  principal_id         = var.vh_mi_principal_id
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
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.azkvap
  ]
}