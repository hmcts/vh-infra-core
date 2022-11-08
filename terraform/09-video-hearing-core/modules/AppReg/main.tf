locals {
  app_directory_roles = flatten([
    for app, roles in var.app_directory_roles : [
      for role in roles : {
        app  = app
        role = role
      }
    ] if roles != []
  ])

  scope_list = flatten([
    for scope_key, scopes in var.api_scopes : [
      for scope in scopes :
      {
        "name" : scope_key
        "scope" : scope.value
      }
    ]
  ])
  scope_map = {
    for scopes in local.scope_list : "${scopes.name}_${scopes.scope}" => scopes
  }

  app_roles_list = flatten([
    for app_key, app_roles in var.app_roles : [
      for app_role_key, app_role in app_roles :
      {
        "app_key" : app_key
        "app_role_name" : app_role_key
        "app_role" : app_role
      }
    ]
  ])
  app_roles_map = {
    for app_role in local.app_roles_list : "${app_role.app_key}_${app_role.app_role_name}" =>
    {
      "app_key" : app_role.app_key
      "app_role_name" : app_role.app_role_name
      "app_role_id" : app_role.app_role.id
      "app_role_value" : app_role.app_role.value
    }
  }
}

resource "random_uuid" "scopes" {
  for_each = local.scope_map
}


resource "azuread_application" "app_reg" {
  for_each     = var.app_conf
  display_name = "a${each.key}.${var.environment}.platform.hmcts.net"
  identifier_uris = [
    for item in each.value.identifier_uris :
    var.environment == "prod" ? replace(item, ".prod.", ".") : replace(item, "stg", "staging")
  ]


  web {
    homepage_url = var.environment == "prod" ? replace("https://${each.key}.${var.environment}.platform.hmcts.net", ".prod.", ".") : replace("https://${each.key}.${var.environment}.platform.hmcts.net", "stg", "staging")
    redirect_uris = [
      for item in each.value.reply_urls_web :
      var.environment == "prod" ? tostring(replace(item, ".prod.", ".")) : tostring(replace(item, "stg", "staging"))
    ]

    implicit_grant {
      id_token_issuance_enabled = true
    }
  }

  single_page_application {
    redirect_uris = [
      for item in each.value.reply_urls_spa :
      var.environment == "prod" ? tostring(replace(item, ".prod.", ".")) : tostring(replace(item, "stg", "staging"))
    ]
  }

  owners = [data.azuread_client_config.current.object_id]

  api {
    mapped_claims_enabled          = false
    requested_access_token_version = each.value.requested_access_token_version

    dynamic "oauth2_permission_scope" {
      for_each = lookup(var.api_scopes, each.key, )
      content {
        admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
        admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
        user_consent_description   = oauth2_permission_scope.value.user_consent_description
        user_consent_display_name  = oauth2_permission_scope.value.user_consent_display_name
        enabled                    = oauth2_permission_scope.value.enabled
        id                         = lookup(random_uuid.scopes, "${each.key}_${oauth2_permission_scope.value.value}").result
        type                       = "User"
        value                      = oauth2_permission_scope.value.value
      }
    }
  }

  dynamic "required_resource_access" {
    for_each = lookup(var.api_permissions, each.key, )
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
    for_each = lookup(var.app_roles, each.key, )
    content {
      id                   = app_role.value.id
      display_name         = app_role.key
      description          = app_role.value.description
      enabled              = app_role.value.is_enabled
      value                = app_role.value.value
      allowed_member_types = app_role.value.allowed_member_types
    }
  }

  optional_claims {
    dynamic "access_token" {
      for_each = [
        for token in each.value.optional_claims :
        token if token.type == "access_token"
      ]
      content {
        name                  = access_token.value.name
        essential             = access_token.value.essential
        additional_properties = access_token.value.additional_properties
      }
    }

    dynamic "id_token" {
      for_each = [
        for token in each.value.optional_claims :
        token if token.type == "id_token"
      ]
      content {
        name                  = id_token.value.name
        essential             = id_token.value.essential
        additional_properties = id_token.value.additional_properties
      }
    }

    dynamic "saml2_token" {
      for_each = [
        for token in each.value.optional_claims :
        token if token.type == "saml2"
      ]
      content {
        name                  = saml2_token.value.name
        essential             = saml2_token.value.essential
        additional_properties = saml2_token.value.additional_properties
      }
    }
  }

  # lifecycle {
  #   ignore_changes = [
  #     single_page_application
  #   ]
  # }
}

# Create app reg secret
resource "time_rotating" "app_reg_password" {
  rotation_days = 365
}

resource "azuread_application_password" "create_secret" {
  for_each              = var.app_conf
  application_object_id = azuread_application.app_reg[each.key].id
  rotate_when_changed = {
    rotation = time_rotating.app_reg_password.id
  }
}

# Create service principal
resource "azuread_service_principal" "create_sp" {
  for_each                     = var.app_conf
  application_id               = azuread_application.app_reg[each.key].application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

data "azurerm_key_vault" "key_vault" {
  for_each            = var.app_conf
  name                = "${each.key}-${var.environment}"
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "client_id" {
  for_each = var.app_conf
  name     = "azuread--clientid"
  value    = azuread_application.app_reg[each.key].application_id
  #key_vault_id = data.azurerm_key_vault.key_vault[each.key].id
  key_vault_id = var.app_keyvaults_map[each.key].id
  # FromTFSec
  content_type    = "secret"
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = var.app_conf
  name     = "azuread--clientsecret"
  value    = azuread_application_password.create_secret[each.key].value
  #key_vault_id = data.azurerm_key_vault.key_vault[each.key].id
  key_vault_id = var.app_keyvaults_map[each.key].id
  # FromTFSec
  content_type    = "secret"
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "identifier_uri" {
  for_each = var.app_conf
  name     = "azuread--identifieruri"
  value    = var.environment == "stg" ? replace(each.value.identifier_uris[0], "stg", "staging") : replace(each.value.identifier_uris[0], ".prod", "")
  #key_vault_id = data.azurerm_key_vault.key_vault[each.key].id
  key_vault_id = var.app_keyvaults_map[each.key].id
  # FromTFSec
  content_type    = "secret"
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags
}



data "azurerm_key_vault" "vh-infra-core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "videoweb" {
  name                = "vh-video-web-${var.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "videoweb-clientid" {
  name         = "azuread--clientid"
  key_vault_id = data.azurerm_key_vault.videoweb.id


  depends_on = [azurerm_key_vault_secret.client_id, azurerm_key_vault_secret.secret]
}

resource "azurerm_key_vault_secret" "azuread-vhvideowebclientid" {
  name         = "azuread--vhvideowebclientid"
  value        = data.azurerm_key_vault_secret.videoweb-clientid.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "services-vhvideowebclientid" {
  name         = "services--videowebclientid"
  value        = data.azurerm_key_vault_secret.videoweb-clientid.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags
}

data "azurerm_key_vault" "userapi" {
  name                = "vh-video-api-${var.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "userapi-clientid" {
  name         = "azuread--clientid"
  key_vault_id = data.azurerm_key_vault.userapi.id

  depends_on = [azurerm_key_vault_secret.client_id, azurerm_key_vault_secret.secret]
}
data "azurerm_key_vault_secret" "userapi-clientsecret" {
  name         = "azuread--clientsecret"
  key_vault_id = data.azurerm_key_vault.userapi.id

  depends_on = [azurerm_key_vault_secret.client_id, azurerm_key_vault_secret.secret]
}

resource "azurerm_key_vault_secret" "azuread-userapiclientid" {
  name         = "azuread--userapiclientid"
  value        = data.azurerm_key_vault_secret.userapi-clientid.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "azuread-userapiclientssecret" {
  name         = "azuread--userapiclientsecret"
  value        = data.azurerm_key_vault_secret.userapi-clientsecret.value
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = "2032-12-31T00:00:00Z"
  tags            = var.tags
}

data "azuread_service_principal" "app_sp" {
  for_each       = azuread_application.app_reg
  application_id = each.value.application_id
}

resource "azuread_app_role_assignment" "groups" {
  for_each            = local.app_roles_map
  app_role_id         = data.azuread_service_principal.app_sp[each.value.app_key].app_role_ids[each.value.app_role_value]
  principal_object_id = each.value.app_role_id
  resource_object_id  = data.azuread_service_principal.app_sp[each.value.app_key].object_id
}

data "azuread_client_config" "current" {}

data "azuread_service_principal" "vh_service_principal" {
  for_each       = var.app_directory_roles
  application_id = azuread_application.app_reg[each.key].application_id
}

resource "azuread_directory_role_assignment" "app_directory_roles" {
  for_each = {
    for r in local.app_directory_roles : "${r.app}.${r.role}" => r
  }
  role_id             = each.value.role
  principal_object_id = data.azuread_service_principal.vh_service_principal[each.value.app].object_id
}