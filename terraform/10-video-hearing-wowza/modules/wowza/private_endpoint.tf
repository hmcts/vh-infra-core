## Data sources
data "azurerm_resource_group" "vh-infra-core" {
  name = "vh-infra-core-${var.environment}"
}

data "azurerm_resource_group" "ss-network-rg" {
  name = "ss-${var.environment}-network-rg"
}

data "azurerm_virtual_network" "ss_vnet" {
  name                = "ss-${var.environment}-vnet"
  resource_group_name = "ss-${var.environment}-network-rg"
}

data "azurerm_subnet" "ss_subnet" {
  name                 = "vh_private_endpoints"
  virtual_network_name = "ss-${var.environment}-vnet"
  resource_group_name  = "ss-${var.environment}-network-rg"
}

## Create Wowza Storage endpoint for AKS

resource "azurerm_private_endpoint" "wowza_storage_endpoint_aks" {
  name                = "vh-wowza-aks-storage-endpoint-${var.environment}"
  location            = azurerm_resource_group.wowza.location
  resource_group_name = azurerm_resource_group.wowza.name
  subnet_id           = data.azurerm_subnet.ss_subnet.id

  private_service_connection {
    name                           = "wowza-${var.environment}-storageconnection"
    private_connection_resource_id = module.wowza_recordings.storageaccount_id
    subresource_names              = ["Blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "vh-wowza-aks-storage-endpoint-${var.environment}-dnszonegroup"
    private_dns_zone_ids = [var.private_dns_zone_group]
  }
  tags = var.tags
}


# BLANKED OUT AS PERMISSION NEEDS GRANTING TO RUN AGAINST SUBSCRTIPTION 4bb049c8-33f3-4860-91b4-9ee45375cc18 before the DNS chanes will work
# Code blocks for this reside in 20-main.tf, 00-init.tf & private_endpoint.tf
resource "azurerm_private_dns_a_record" "wowza_storage_endpoint_dns" {
  provider            = azurerm.private-endpoint-dns
  name                = "vh-wowza-storage-${var.environment}"
  zone_name           = var.private_dns_zone_group_name
  resource_group_name = "core-infra-intsvc-rg" #"vh-hearings-reform-hmcts-net-dns-zone"
  ttl                 = 300
  records             = [azurerm_private_endpoint.wowza_storage_endpoint_aks.private_service_connection[0].private_ip_address]
}


