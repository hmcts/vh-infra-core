resource "random_password" "certPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

resource "random_password" "restPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

resource "random_password" "streamPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

resource "azurerm_key_vault_secret" "restPassword" {
  name         = "restPassword-${var.environment}"
  value        = random_password.restPassword.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "streamPassword" {
  name         = "streamPassword-${var.environment}"
  value        = random_password.streamPassword.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "configPassword" {
  name         = "wowzaconfiguration--password"
  value        = random_password.restPassword.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_user_assigned_identity" "wowza_cert" {
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  name = "wowza-cert-${var.environment}-mi"
  tags = var.tags
}
data "azurerm_key_vault" "acmekv" {
  name                = "acmedtssds${var.environment}"
  resource_group_name = "sds-platform-${var.environment}-rg"
}
resource "azurerm_role_assignment" "kv_access" {
  scope                = data.azurerm_key_vault.acmekv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.wowza_cert.client_id
}

data "template_file" "cloudconfig" {
  template = file(var.cloud_init_file)
  vars = {
    certPassword            = random_password.certPassword.result
    storageAccountName      = azurerm_storage_account.wowza_recordings.name
    storageContainerName    = azurerm_storage_container.recordings.name
    msiClientId             = var.storage_msi_client_id
    restPassword            = md5("wowza:Wowza:${random_password.restPassword.result}")
    streamPassword          = md5("wowza:Wowza:${random_password.streamPassword.result}")
    managedIdentityClientId = azurerm_user_assigned_identity.wowza_cert.client_id
    certName                = var.environment == "prod" ? "wildcard-wildcard-hearings-hmcts-net" : "wildcard-${var.environment}-platform-hmcts-net"
    keyVaultName            = data.azurerm_key_vault.acmekv.name
    domain                  = var.environment == "prod" ? "vh-wowza.hearings.reform.hmcts.net" : "vh-wowza.${var.environment}.platform.hmcts.net"
  }
}

data "template_cloudinit_config" "wowza_setup" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
}
