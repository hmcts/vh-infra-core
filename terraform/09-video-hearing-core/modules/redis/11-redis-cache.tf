#--------------------------------------------------------------
# Redis Cache Standard
#--------------------------------------------------------------

resource "azurerm_redis_cache" "redis_cache_standard" {
  name                = trim(var.resource_group_name, "-")
  location            = var.location
  resource_group_name = var.resource_group_name

  capacity = local.sku.capacity
  family   = local.sku.family
  sku_name = local.sku.sku_name

  enable_non_ssl_port = var.redis_cache_enable_non_ssl_port

  redis_configuration {
    # Unable to set due to using Basic SKU for lower environments
    #maxmemory_reserved = var.redis_cache_standard_maxmemory_reserved
    #maxmemory_delta    = var.redis_cache_standard_maxmemory_delta
    maxmemory_policy = var.redis_cache_standard_maxmemory_policy
  }
  tags = var.tags
}

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_key_vault_secret" "rediscache_connection_str" {
  name         = "connectionstrings--rediscache"
  value        = azurerm_redis_cache.redis_cache_standard.primary_connection_string
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  # FromTFSec
  content_type    = "secret"
  expiration_date = timeadd(timestamp(), "8760h")
  tags            = var.tags
}
