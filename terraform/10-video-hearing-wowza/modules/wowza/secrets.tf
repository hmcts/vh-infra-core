locals {
  secret_prefix = "wowzaconfiguration"
  secrets = {
    "azure-storage-directory"   = "/wowzadata/azurecopy",
    "endpoint-streaming"        = "rtmps://${local.wowza_domain}:443/",
    "endpoint"                  = "https://${local.wowza_domain}:443/",
    "HostName"                  = "_defaultVHost_"
    "managedidentityclientid"   = data.azurerm_user_assigned_identity.vh_mi.client_id,
    "public-endpoint"           = "https://${local.wowza_domain}:443/",
    "public-restendpoint--0"    = "https://${local.wowza_domain}:8090/",
    "public-restendpoint--1"    = "https://${local.wowza_domain}:8091/",
    "restendpoint--0"           = "https://${local.wowza_domain}:8090/",
    "restendpoint--1"           = "https://${local.wowza_domain}:8091/",
    "restPassword"              = random_password.restPassword.result,
    "ServerName"                = "_defaultServer_"
    "ssh-private"               = tls_private_key.vm.private_key_openssh
    "ssh-public"                = tls_private_key.vm.public_key_openssh
    "storage-account-container" = local.recordings_container_name,
    "storage-account-endpoint"  = module.wowza_recordings.storageaccount_primary_blob_endpoint,
    "storage-account"           = module.wowza_recordings.storageaccount_name,
    "storageaccountkey"         = module.wowza_recordings.storageaccount_primary_access_key,
    "streamPassword"            = random_password.streamPassword.result,
    "username"                  = var.admin_user
    "wowza-storage-directory"   = "usr/local/WowzaStreamingEngine/content/"
    "Splunk-admin"              = local.splunk_admin_username
    "Splunk-password"           = random_password.splunk_admin_password.result
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

data "azurerm_user_assigned_identity" "vh_mi" {
  name                = "vh-${var.environment}-mi"
  resource_group_name = "managed-identities-${var.environment}-rg"
}