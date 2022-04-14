output "redis_id" {
  value = azurerm_redis_cache.redis_cache_standard.id
}

output "name" {
  value = azurerm_redis_cache.redis_cache_standard.name
}

output "connection_string" {
  value = azurerm_redis_cache.redis_cache_standard.primary_connection_string
}