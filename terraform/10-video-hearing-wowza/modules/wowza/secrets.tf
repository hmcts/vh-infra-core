locals {
  secret_prefix = "wowzaconfiguration"
  secrets = {
    "managedidentityclientid"             = azurerm_user_assigned_identity.wowza_storage.client_id,
    "storageaccountkey"                   = module.wowza_recordings.storageaccount_primary_access_key,
    "restPassword"                        = random_password.restPassword.result,
    "streamPassword"                      = random_password.streamPassword.result,
    "azure-storage-directory"             = "/wowzadata/azurecopy",
    "endpoint"                            = "https://${local.wowza_domain}:443",
    "wowzaconfiguration--restendpoint--0" = "https://${local.wowza_domain}:8090",
    "wowzaconfiguration--restendpoint--1" = "https://${local.wowza_domain}:8091",
    "storage-account"                     = module.wowza_recordings.storageaccount_name,
    "storage-account-endpoint"            = module.wowza_recordings.storageaccount_primary_blob_endpoint,
    "storage-account-container"           = local.recordings_container_name,
    "username"                            = var.admin_user
    "ssh-public"                          = tls_private_key.vm.public_key_openssh
    "ssh-private"                         = tls_private_key.vm.private_key_openssh
    "ServerName"                          = "_defaultServer_"
  }
}

resource "azurerm_key_vault_secret" "secret" {
  for_each        = local.secrets
  key_vault_id    = var.key_vault_id
  name            = "${local.secret_prefix}--${each.key}"
  value           = each.value
  tags            = var.tags
  content_type    = ""
  expiration_date = "2032-12-31T00:00:00Z"
}
