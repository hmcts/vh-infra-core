resource "azuread_application" "app_reg" {
  for_each = var.app_conf
  name                       = "a${each.key}.${var.environment}.platform.hmcts.net"
  homepage                   = "https://${each.key}.${var.environment}.platform.hmcts.net"
  identifier_uris            = each.value.identifier_uris
  reply_urls                 = each.value.reply_urls
  available_to_other_tenants = each.value.available_to_other_tenants
  oauth2_allow_implicit_flow = each.value.oauth2_allow_implicit_flow
  type                       = each.value.type
  public_client              = false
  group_membership_claims    = "None"
  #owners                     = ["dad89ade-ef6a-41ef-9729-332402704dc9"]
  dynamic "required_resource_access" {
    for_each = lookup(var.api_permissions, each.key,)
    content {
      resource_app_id = required_resource_access.value.id
      dynamic "resource_access" {
        for_each = required_resource_access.value.access
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }
  dynamic "app_role" {
    for_each = lookup(var.app_roles, each.key,)
    content {
      display_name = app_role.key
      description  = app_role.value.description
      is_enabled   = app_role.value.is_enabled
      value        = app_role.value.value
      allowed_member_types = app_role.value.allowed_member_types
    }
  }
}

# Generate Random Password
resource "random_password" "random_secret" {
  for_each = var.app_conf
  length = 32
  special = true
  override_special = "_%@"
}

# Create app reg secret
resource "azuread_application_password" "create_secret" {
  for_each = var.app_conf
  application_object_id = azuread_application.app_reg[each.key].id
  description           = ""
  value                 = random_password.random_secret[each.key].result
  end_date_relative     = "8760h"
}

# Create service principal
resource "azuread_service_principal" "create_sp" {
  for_each = var.app_conf
  application_id               = azuread_application.app_reg[each.key].application_id
  app_role_assignment_required = false
}

data "azurerm_key_vault" "key_vault" {
  for_each = var.app_conf
  name = "${each.key}-${var.environment}"
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "client_id" {
  for_each = var.app_conf
  name         = "azuread--clientid"
  value        = azuread_application.app_reg[each.key].application_id
  #key_vault_id = data.azurerm_key_vault.key_vault[each.key].id
  key_vault_id = var.app_keyvaults_map[each.key].id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags = var.tags
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.app_conf
  name         = "azuread--clientsecret"
  value        = azuread_application_password.create_secret[each.key].value
  #key_vault_id = data.azurerm_key_vault.key_vault[each.key].id
  key_vault_id = var.app_keyvaults_map[each.key].id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags = var.tags
}

data "azurerm_key_vault" "vh-infra-core" {
  name = "vh-infra-core-${var.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "videoweb" {
  name = "vh-video-web-${var.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "videoweb-clientid" {
  name         = "azuread--clientid"
  key_vault_id = data.azurerm_key_vault.videoweb.id
  # FromTFSec
  content_type    = "secret"

  depends_on = [ azurerm_key_vault_secret.client_id, azurerm_key_vault_secret.secret ]
}

resource "azurerm_key_vault_secret" "azuread-vhvideowebclientid" {
  name         = "azuread--vhvideowebclientid"
  value        = data.azurerm_key_vault_secret.videoweb-clientid.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags = var.tags
}

resource "azurerm_key_vault_secret" "services-vhvideowebclientid" {
  name         = "services--videowebclientid"
  value        = data.azurerm_key_vault_secret.videoweb-clientid.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags = var.tags
}

data "azurerm_key_vault" "userapi" {
  name = "vh-video-api-${var.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "userapi-clientid" {
   name         = "azuread--clientid"
  key_vault_id = data.azurerm_key_vault.userapi.id
  # FromTFSec
  content_type    = "secret"

  depends_on = [ azurerm_key_vault_secret.client_id, azurerm_key_vault_secret.secret ]
}
data "azurerm_key_vault_secret" "userapi-clientsecret" {
   name         = "azuread--clientsecret"
  key_vault_id = data.azurerm_key_vault.userapi.id
  # FromTFSec
  content_type    = "secret"

  depends_on = [ azurerm_key_vault_secret.client_id, azurerm_key_vault_secret.secret ]
}

resource "azurerm_key_vault_secret" "azuread-userapiclientid" {
  name         = "azuread--userapiclientid"
  value        = data.azurerm_key_vault_secret.userapi-clientid.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags = var.tags
}

resource "azurerm_key_vault_secret" "azuread-userapiclientssecret" {
  name         = "azuread--userapiclientsecret"
  value        = data.azurerm_key_vault_secret.userapi-clientsecret.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags = var.tags
}

