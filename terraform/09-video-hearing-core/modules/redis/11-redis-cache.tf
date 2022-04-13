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
