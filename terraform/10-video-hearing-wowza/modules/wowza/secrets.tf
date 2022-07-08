locals {
  secret_prefix = "wowzaconfiguration--"
}

module "KeyVault_Cvp_Secrets" {
  source       = "./../../../09-video-hearing-core/modules/KeyVaults/Secrets"
  key_vault_id = var.key_vault_id

  tags = var.tags
  secrets = [
    {
      name         = "${local.secret_prefix}managedidentityclientid"
      value        = azurerm_user_assigned_identity.wowza_storage.client_id
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}storageaccountkey"
      value        = azurerm_storage_account.wowza_recordings.primary_access_key
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}restPassword-${var.environment}"
      value        = random_password.restPassword.result
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}streamPassword-${var.environment}"
      value        = random_password.streamPassword.result
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}azure-storage-directory"
      value        = "/wowzadata/azurecopy"
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}endpoint"
      value        = "http://${local.wowza_domain}:443"
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}storage-account"
      value        = azurerm_storage_account.wowza_recordings.name
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}storage-account-endpoint"
      value        = azurerm_storage_account.wowza_recordings.primary_blob_endpoint
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}storage-account-container"
      value        = azurerm_storage_container.recordings.name
      tags         = var.tags
      content_type = "secret"
    },
    {
      name         = "${local.secret_prefix}username"
      value        = var.admin_user
      tags         = var.tags
      content_type = "secret"
    }
  ]

}
