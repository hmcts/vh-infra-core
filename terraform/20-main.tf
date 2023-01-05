#--------------------------------------------------------------
# VH - Resource Group
#--------------------------------------------------------------

resource "azurerm_resource_group" "vh-infra-core" {
  name     = "${local.std_prefix}${local.suffix}"
  location = var.location
  tags     = local.common_tags
}

#--------------------------------------------------------------
# VH - KeyVaults
#--------------------------------------------------------------

resource "random_password" "temporarypassword" {
  length           = 16
  special          = true
  override_special = "!"
}

resource "random_password" "defaultpassword" {
  length           = 16
  special          = true
  override_special = "!"
}

locals {
  external_passwords = {
    "azuread--temporarypassword" = random_password.temporarypassword.result
    "defaultpassword"            = random_password.temporarypassword.result
  }
}

module "KeyVaults" {
  source             = "./modules/KeyVaults"
  environment        = var.environment
  external_passwords = local.external_passwords

  resource_group_name = azurerm_resource_group.vh-infra-core.name
  location            = azurerm_resource_group.vh-infra-core.location
  resource_prefix     = local.std_prefix
  keyvaults           = local.keyvaults
  vh_mi_principal_id  = azurerm_user_assigned_identity.vh_mi.principal_id

  tags = local.common_tags
}


#--------------------------------------------------------------
# VH - KeyVaults Core Secrects
#--------------------------------------------------------------

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = azurerm_resource_group.vh-infra-core.name
  resource_group_name = azurerm_resource_group.vh-infra-core.name

  depends_on = [
    module.KeyVaults
  ]
}

module "KeyVault_Secrets" {
  source         = "./modules/KeyVaults/Secrets"
  key_vault_id   = module.KeyVaults.keyvault_id
  key_vault_name = module.KeyVaults.keyvault_name

  tags = local.common_tags
  secrets = [
    {
      name         = "applicationinsights--instrumentationkey"
      value        = module.Monitoring.instrumentation_key
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "azuread--appinsightskey"
      value        = module.Monitoring.instrumentation_key
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "azuread--tenantid"
      value        = var.vh_tenant_id
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "connectionstrings--rediscache"
      value        = module.Redis.connection_string
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "connectionstrings--signalr"
      value        = replace(module.SignalR.connection_string, "vh-infra-core-${var.environment}.service.signalr.net", var.signalr_custom_domain_name)
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "hvhearingsapiadmin"
      value        = module.VHDataServices.admin_password
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "connectionstrings--vhbookings"
      value        = module.VHDataServices.bookings_api_connection_string
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "connectionstrings--vhvideo"
      value        = module.VHDataServices.video_connection_string
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "connectionstrings--vhnotificationsapi"
      value        = module.VHDataServices.notification_connection_string
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "connectionstrings--testapi"
      value        = module.VHDataServices.test_api_connection_string
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "servicebusqueue--connectionstring"
      value        = module.VHDataServices.service_bus_connection_string
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "connectionstrings--videoapi"
      value        = module.VHDataServices.video_api_connection_string
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "vh-infra-core-${var.environment}-sql-username"
      value        = module.VHDataServices.admin_username
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "vh-infra-core-${var.environment}-sql-password"
      value        = module.VHDataServices.admin_password
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "storage-account-key"
      value        = module.storage.storageaccount_primary_access_key
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "storage-account-name"
      value        = module.storage.storageaccount_name
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "storage-account-endpoint"
      value        = module.storage.storageaccount_primary_blob_endpoint
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "storage-account-container-elinks-name"
      value        = local.elinks_container_name
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "storage-account-web-jobs-connection-string"
      value        = "DefaultEndpointsProtocol=https;AccountName=${module.storage.storageaccount_name};AccountKey=${module.storage.storageaccount_primary_access_key};EndpointSuffix=core.windows.net"
      tags         = local.common_tags
      content_type = "secret"
    }
  ]

  depends_on = [
    module.KeyVaults,
    module.AppReg,
    module.storage
  ]
}

module "input_Secrets" {
  for_each       = { for secret in var.kv_secrets : secret.key_vault_name => secret if secret.key_vault_name != "vh-infra-core" }
  source         = "./modules/KeyVaults/Secrets"
  key_vault_id   = lookup(module.KeyVaults.keyvault_resource, each.value.key_vault_name).resource_id
  key_vault_name = each.value.key_vault_name

  tags = local.common_tags
  secrets = [
    for secret in each.value.secrets :
    {
      name         = secret.name
      value        = secret.value
      tags         = local.common_tags
      content_type = "ado_secret"
    }
  ]

  depends_on = [
    module.KeyVaults
  ]
}

module "input_Secrets_infra_core" {
  for_each       = { for secret in var.kv_secrets : secret.key_vault_name => secret if secret.key_vault_name == "vh-infra-core" }
  source         = "./modules/KeyVaults/Secrets"
  key_vault_id   = module.KeyVaults.keyvault_id
  key_vault_name = each.value.key_vault_name

  secrets = [
    for secret in each.value.secrets :
    {
      name         = secret.name
      value        = secret.value
      tags         = local.common_tags
      content_type = "ado_secret"
    }
  ]

  tags = local.common_tags

  depends_on = [
    module.KeyVaults
  ]
}

#--------------------------------------------------------------
# VH - Storage Group
#--------------------------------------------------------------
locals {
  containers = [{
    name        = local.elinks_container_name
    access_type = "private"
  }]
  tables                = []
  elinks_container_name = "elinks-people"
}
#tfsec:ignore:azure-storage-default-action-deny
module "storage" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"

  env = var.environment

  storage_account_name = replace(lower("${local.std_prefix}${local.suffix}"), "-", "")
  common_tags          = local.common_tags

  default_action = "Allow"

  resource_group_name = azurerm_resource_group.vh-infra-core.name
  location            = azurerm_resource_group.vh-infra-core.location

  access_tier                     = "Hot"
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = "true"

  enable_data_protection = true

  team_name    = "VH"
  team_contact = "#vh-devops"

  tables     = local.tables
  containers = local.containers
}

#--------------------------------------------------------------
# VH - SignalR
#--------------------------------------------------------------

data "azurerm_key_vault" "acmekv" {
  name                = "acmedtssds${var.environment}"
  resource_group_name = "sds-platform-${var.environment}-rg"
}

locals {
  key_vault_cert_name_wildcard = {
    "prod" = "wildcard-hearings-reform-hmcts-net",
    "stg"  = "wildcard-staging-hearings-reform-hmcts-net"
  }
}

module "SignalR" {
  source = "./modules/SignalR"

  name                = "${local.std_prefix}${local.suffix}"
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  managed_identities  = [azurerm_user_assigned_identity.vh_mi.id]
  custom_domain_name  = var.signalr_custom_domain_name
  key_vault_cert_name = var.environment == "stg" || var.environment == "prod" ? lookup(local.key_vault_cert_name_wildcard, var.environment) : "wildcard-${var.environment}-platform-hmcts-net"
  key_vault_uri       = data.azurerm_key_vault.acmekv.vault_uri
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "acmmekv_access_policy" {
  role_definition_name = "Key Vault Secrets User"
  scope                = data.azurerm_key_vault.acmekv.id
  principal_id         = azurerm_user_assigned_identity.vh_mi.principal_id
}

#--------------------------------------------------------------
# VH - Azure Media Service Account
#--------------------------------------------------------------


/* module "AMS" {
  source = "./modules/AMS"

  resource_prefix     = "${local.std_prefix}${local.suffix}"
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  location            = azurerm_resource_group.vh-infra-core.location
  storage_account_id  = module.storage.storageaccount_id


  tags = local.common_tags

} */

#--------------------------------------------------------------
# VH - Redis Cache Standard
#--------------------------------------------------------------

module "Redis" {
  source              = "./modules/redis"
  environment         = var.environment
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  location            = azurerm_resource_group.vh-infra-core.location

  tags = local.common_tags
}

#--------------------------------------------------------------
# VH - App Registrations
#--------------------------------------------------------------

module "AppReg" {
  source = "./modules/AppReg"
  providers = {
    azuread = azuread.vh
  }
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  environment         = var.environment

  app_conf            = local.app_conf
  app_roles           = local.app_roles
  api_permissions     = local.api_permissions
  api_scopes          = local.api_scopes
  app_keyvaults_map   = module.KeyVaults.app_keyvaults_out
  app_directory_roles = local.app_directory_roles

  depends_on = [
    azurerm_resource_group.vh-infra-core,
    module.KeyVaults,
  ]
  tags = local.common_tags
}

#--------------------------------------------------------------
# VH - Monitoring
#--------------------------------------------------------------


module "Monitoring" {
  source              = "./modules/Monitoring"
  location            = azurerm_resource_group.vh-infra-core.location
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  resource_prefix     = "${local.std_prefix}${local.suffix}"

  env = local.environment

  action_groups = {
    "kinly" = {
      emails = split(",", var.emails_kinly)
    }
    "dev" = {
      emails = split(",", var.emails_dev)
    }
    "devops" = {
      emails = split(",", var.emails_devops)
    }
  }

  tags = local.common_tags
}

#--------------------------------------------------------------
# VH - MS SQL Service
#--------------------------------------------------------------


module "VHDataServices" {
  source      = "./modules/VHDataServices"
  environment = var.environment
  public_env  = local.environment == "dev" ? 1 : 0

  databases = var.databases
  queues    = var.queues

  resource_group_name = azurerm_resource_group.vh-infra-core.name
  location            = azurerm_resource_group.vh-infra-core.location
  resource_prefix     = local.std_prefix
  key_vault_id        = module.KeyVaults.keyvault_id
  keyvault_name       = module.KeyVaults.keyvault_name

  tags = local.common_tags

  depends_on = [
    module.KeyVaults
  ]
}


#--------------------------------------------------------------
# VH - AppConfiguration
#--------------------------------------------------------------

/* module "appconfig" {
  source              = "./modules/AppConfiguration"
  location            = azurerm_resource_group.vh-infra-core.location
  resource_group_name = azurerm_resource_group.vh-infra-core.name

  tags = local.common_tags
} */

#--------------------------------------------------------------
# VH - PrivateEndpoint
#--------------------------------------------------------------

module "vh_endpoint" {

  source              = "./modules/PrivateEndpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  environment         = var.environment
  resources = {
    "SQLServer" = {
      resource_id         = module.VHDataServices.server_id
      resource_name       = module.VHDataServices.name
      resource_type       = "sqlServer"
      private_dns_zone_id = data.azurerm_private_dns_zone.sql.id
    }
    "RedisCache" = {
      resource_id         = module.Redis.redis_id
      resource_name       = module.Redis.name
      resource_type       = "redisCache"
      private_dns_zone_id = data.azurerm_private_dns_zone.redis.id
    }
    "SignalR" = {
      resource_id         = module.SignalR.signalr_id
      resource_name       = module.SignalR.name
      resource_type       = "signalr"
      private_dns_zone_id = data.azurerm_private_dns_zone.signalr.id
    }
  }
  tags = local.common_tags
}

module "vh_kv_endpoint" {

  source              = "./modules/PrivateEndpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  environment         = var.environment
  subnet_id           = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/ss-sbox-network-rg/providers/Microsoft.Network/virtualNetworks/ss-sbox-vnet/subnets/vh_private_endpoints"
  resources = tomap({
    for k in module.KeyVaults.keyvault_resource :
    k.resource_name => {
      resource_id         = k.resource_id
      resource_name       = k.resource_name
      resource_type       = k.resource_type
      private_dns_zone_id = data.azurerm_private_dns_zone.kv.id
    }
  })

  tags = local.common_tags
}

resource "azurerm_private_dns_a_record" "kv-dns" {

  provider = azurerm.private-endpoint-dns
  for_each = module.vh_kv_endpoint.endpoint_resource

  name                = lower(format("%s-%s", lookup(each.value, "resource_name"), var.environment))
  zone_name           = lookup(local.dns_zone_mapping, (lookup(each.value, "resource_type")))
  resource_group_name = local.dns_zone_resource_group_name
  ttl                 = 3600
  records             = [lookup(each.value, "resource_ip")]
}

data "azurerm_resource_group" "managed-identities-rg" {
  name = "managed-identities-${var.environment}-rg"
}

resource "azurerm_user_assigned_identity" "vh_mi" {
  name                = "vh-${var.environment}-mi"
  resource_group_name = data.azurerm_resource_group.managed-identities-rg.name
  location            = data.azurerm_resource_group.managed-identities-rg.location
  tags                = local.common_tags
}
