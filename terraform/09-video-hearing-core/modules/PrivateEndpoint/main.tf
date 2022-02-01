data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "ss_subnet" {
  name                  = "vh_private_endpoints"
  virtual_network_name  = "ss-${var.environment}-vnet"
  resource_group_name   = "ss-${var.environment}-network-rg"
}

resource "azurerm_private_endpoint" "vh_endpoint" {
  for_each            = var.resources

  name                = format("endpoint-%s", lookup(each.value, "resource_name"))
  location            = var.location
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
  subnet_id           = data.azurerm_subnet.ss_subnet.id

  private_service_connection {
    name                                = "vh-${var.environment}-aksserviceconnection"
    private_connection_resource_id      = lookup(each.value, "resource_id")
    is_manual_connection                = false
    subresource_names                   = [lookup(each.value, "resource_type")]
  }
  tags = var.tags
}

variable "dns_zone_mapping" {
  description = "mapping for endpoint dns"
  type = map
  default = {
    
    "endpoint-SQLServer" = "privatelink.database.windows.net"
    "endpoint-Redis" = "privatelink.redis.cache.windows.net"
    "endpoint-Signal" = "privatelink.service.signalr.net"
    "vault" = "privatelink.vaultcore.azure.net"

  }
}



resource azurerm_dns_a_record "test" {
  for_each = {for e, o in azurerm_private_endpoint.vh_endpoint : e => o.name }
  
  name                = each.key
  zone_name           = lookup(var.dns_zone_mapping, each.value.private_service_connection[0].subresource_names)
  resource_group_name = "core-infra-intsvc-rg"
  ttl                 = 3600
  records             = [each.value.private_service_connection[1].private_ip_address]
}




