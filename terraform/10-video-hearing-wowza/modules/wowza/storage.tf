locals {
  tables = []
  containers = [{
    name        = local.recordings_container_name
    access_type = "private"
  }]
  recordings_container_name = "recordings"
}

#tfsec:ignore:azure-storage-default-action-deny
module "wowza_recordings" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"

  env = var.environment

  storage_account_name = replace(lower(var.service_name), "-", "")
  common_tags          = var.tags

  default_action = "Allow"

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  access_tier                     = "Cool"
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "RAGRS"
  allow_nested_items_to_be_public = "true"

  enable_data_protection = true

  team_name    = "VH"
  team_contact = "#vh-devops"

  tables     = local.tables
  containers = local.containers
}

resource "azurerm_private_endpoint" "wowza_storage" {
  name = "${module.wowza_recordings.storageaccount_name}-storage-endpoint"

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  subnet_id = azurerm_subnet.wowza.id

  private_service_connection {
    name                           = "${var.service_name}-privateserviceconnection"
    private_connection_resource_id = module.wowza_recordings.storageaccount_id
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
  name                = module.wowza_recordings.storageaccount_name
  zone_name           = azurerm_private_dns_zone.blob.name
  resource_group_name = azurerm_resource_group.wowza.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.wowza_storage.private_service_connection.0.private_ip_address]
  tags                = var.tags
}


