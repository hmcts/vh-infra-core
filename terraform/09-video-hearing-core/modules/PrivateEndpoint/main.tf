data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "ss_subnet" {
  name                 = "vh_private_endpoints"
  virtual_network_name = "ss-${var.environment}-vnet"
  resource_group_name  = "ss-${var.environment}-network-rg"
}

resource "azurerm_private_endpoint" "vh_endpoint" {
  for_each = var.resources

  name                = format("%s-%s", lookup(each.value, "resource_name"), lookup(each.value, "resource_type"))
  location            = var.location
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
  subnet_id           = data.azurerm_subnet.ss_subnet.id

  private_service_connection {
    name                           = "vh-${var.environment}-aksserviceconnection"
    private_connection_resource_id = lookup(each.value, "resource_id")
    is_manual_connection           = false
    subresource_names              = [lookup(each.value, "resource_type")]
  }

  private_dns_zone_group {
    name                 = "vh-${var.environment}-aksserviceconnection"
    private_dns_zone_ids = var.private_dns_zone_group_ids
  }

  tags = var.tags
}

