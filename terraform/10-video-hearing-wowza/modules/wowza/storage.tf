resource "azurerm_storage_account" "wowza_recordings" {
  name                = replace(lower(var.service_name), "-", "")
  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  access_tier               = "Cool"
  account_kind              = "BlobStorage"
  account_tier              = "Standard"
  account_replication_type  = "RAGRS"
  enable_https_traffic_only = true
  tags                      = var.tags
}

resource "azurerm_storage_container" "recordings" {
  name                  = "recordings"
  storage_account_name  = azurerm_storage_account.wowza_recordings.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "wowza_storage" {
  name = "${azurerm_storage_account.wowza_recordings.name}-storage-endpoint"

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  subnet_id = azurerm_subnet.wowza.id

  private_service_connection {
    name                           = "${var.service_name}-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.wowza_recordings.id
    subresource_names              = ["Blob"]
    is_manual_connection           = false
  }
  tags = var.tags
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.wowza.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "wowza" {
  name                  = var.service_name
  resource_group_name   = azurerm_resource_group.wowza.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.wowza.id
  registration_enabled  = true
  tags                  = var.tags
}

resource "azurerm_private_dns_a_record" "wowza_storage" {
  name                = azurerm_storage_account.wowza_recordings.name
  zone_name           = azurerm_private_dns_zone.blob.name
  resource_group_name = azurerm_resource_group.wowza.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.wowza_storage.private_service_connection.0.private_ip_address]
  tags                = var.tags
}


