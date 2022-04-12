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

module "KeyVaults" {
  source             = "./modules/KeyVaults"
  environment        = var.environment
  external_passwords = var.external_passwords

  resource_group_name = azurerm_resource_group.vh-infra-core.name
  resource_prefix     = local.std_prefix
  keyvaults           = local.keyvaults

  tags = local.common_tags
}


#--------------------------------------------------------------
# VH - Storage Group
#--------------------------------------------------------------

#tfsec:ignore:azure-storage-default-action-deny
resource "azurerm_storage_account" "vh-infra-core" {
  name                = replace(lower("${local.std_prefix}${local.suffix}"), "-", "")
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  location            = azurerm_resource_group.vh-infra-core.location
  min_tls_version     = "TLS1_2"

  access_tier               = "Hot"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  tags = local.common_tags
}

#--------------------------------------------------------------
# VH - SignalR
#--------------------------------------------------------------

module "SignalR" {
  source      = "./modules/SignalR"
  environment = var.environment

  resource_prefix     = "${local.std_prefix}${local.suffix}"
  resource_group_name = azurerm_resource_group.vh-infra-core.name

  tags = local.common_tags
}

#--------------------------------------------------------------
# VH - Azure Media Service Account
#--------------------------------------------------------------


module "AMS" {
  source = "./modules/AMS"

  resource_prefix     = "${local.std_prefix}${local.suffix}"
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  storage_account_id  = azurerm_storage_account.vh-infra-core.id


  tags = local.common_tags
}

#--------------------------------------------------------------
# VH - Redis Cache Standard
#--------------------------------------------------------------

module "Redis" {
  source              = "./modules/redis"
  environment         = var.environment
  resource_group_name = azurerm_resource_group.vh-infra-core.name

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

  app_conf          = local.app_conf
  app_roles         = local.app_roles
  api_permissions   = local.api_permissions
  app_keyvaults_map = module.KeyVaults.app_keyvaults_out

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

  tags = local.common_tags
}

#--------------------------------------------------------------
# VH - MS SQL Service
#--------------------------------------------------------------


module "VHDataServices" {
  source      = "./modules/VHDataServices"
  environment = var.environment
  public_env  = local.environment == "dev" ? 1 : 0

  databases = {
    vhbookings = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
    vhvideo = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
    vhnotification = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
  }
  queues = {
    booking = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
    video = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
  }
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  location            = azurerm_resource_group.vh-infra-core.location
  resource_prefix     = local.std_prefix


  tags = local.common_tags
}


#--------------------------------------------------------------
# VH - AppConfiguration
#--------------------------------------------------------------

module "appconfig" {
  source              = "./modules/AppConfiguration"
  location            = azurerm_resource_group.vh-infra-core.location
  resource_group_name = azurerm_resource_group.vh-infra-core.name

  tags = local.common_tags
}

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

resource "azurerm_private_dns_a_record" "endpoint-dns" {

  provider = azurerm.private-endpoint-dns
  for_each = module.vh_endpoint.endpoint_resource

  name                = lower(format("%s-%s.%s", "vh-infra-core", var.environment, lookup(local.dns_zone_mapping, (lookup(each.value, "resource_type")))))
  zone_name           = lookup(local.dns_zone_mapping, (lookup(each.value, "resource_type")))
  resource_group_name = local.dns_zone_resource_group_name
  ttl                 = 3600
  records             = [lookup(each.value, "resource_ip")]
}


module "vh_kv_endpoint" {

  source              = "./modules/PrivateEndpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.vh-infra-core.name
  environment         = var.environment
  subnet_id           = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/ss-sbox-network-rg/providers/Microsoft.Network/virtualNetworks/ss-sbox-vnet/subnets/vh_private_endpoints"
  resources = tomap({
    for k, v in module.KeyVaults : k => {
      resource_id         = v.keyvault_id
      resource_name       = v.keyvault_name
      resource_type       = "vault"
      private_dns_zone_id = data.azurerm_private_dns_zone.kv.id
    }
  })

  tags = local.common_tags
}

resource "azurerm_private_dns_a_record" "kv-dns" {

  provider = azurerm.private-endpoint-dns
  for_each = module.vh_kv_endpoint.endpoint_resource

  name                = lower(format("%s-%s.%s", lookup(each.value, "resource_name"), var.environment, lookup(local.dns_zone_mapping, (lookup(each.value, "resource_type")))))
  zone_name           = lookup(local.dns_zone_mapping, (lookup(each.value, "resource_type")))
  resource_group_name = local.dns_zone_resource_group_name
  ttl                 = 3600
  records             = [lookup(each.value, "resource_ip")]
}
