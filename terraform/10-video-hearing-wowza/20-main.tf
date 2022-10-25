data "azurerm_client_config" "current" {
}

#--------------------------------------------------------------
# VH - Resource Group
#--------------------------------------------------------------

data "azurerm_resource_group" "vh-infra-core" {
  name = "vh-infra-core-${var.environment}"
}

#--------------------------------------------------------------
# VH - Key Vault Lookup
#--------------------------------------------------------------

data "azurerm_key_vault_secret" "dynatrace_token" {
  name         = "dynatrace-token"
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
}

data "azurerm_key_vault" "vh-infra-core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
}

data "azurerm_key_vault_certificate" "vh-wildcard" {
  name         = "wildcard-hearings-reform-hmcts-net"
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
}

output "certificate_thumbprint" {
  value = data.azurerm_key_vault_certificate.vh-wildcard.thumbprint
}


#--------------------------------------------------------------
# VH - Wowza
#--------------------------------------------------------------

data "azurerm_private_dns_zone" "core-infra-intsvc" {
  provider            = azurerm.private-endpoint-dns
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "core-infra-intsvc-rg"
}

module "wowza" {
  source                      = "./modules/wowza"
  environment                 = var.environment
  location                    = var.location
  service_name                = "vh-infra-wowza-${var.environment}"
  key_vault_id                = data.azurerm_key_vault.vh-infra-core.id
  address_space               = lookup(var.workspace_to_address_space_map, var.environment, "")
  private_dns_zone_group      = data.azurerm_private_dns_zone.core-infra-intsvc.id
  private_dns_zone_group_name = data.azurerm_private_dns_zone.core-infra-intsvc.name
  network_client_id           = var.network_client_id
  network_client_secret       = var.network_client_secret
  network_tenant_id           = var.network_tenant_id
  tags                        = local.common_tags
  route_table                 = var.route_table
  dynatrace_tenant            = var.dynatrace_tenant
  dynatrace_token             = data.azurerm_key_vault_secret.dynatrace_token.value
  schedules                   = var.schedules
  wowza_instance_count        = var.environment == "dev" || var.environment == "test" ? 1 : 2
}