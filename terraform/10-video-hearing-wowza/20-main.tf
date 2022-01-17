#--------------------------------------------------------------
# VH - Resource Group
#--------------------------------------------------------------

data "azurerm_resource_group" "vh-infra-core" {
  name     = "vh-infra-core-${var.environment}"
}

#--------------------------------------------------------------
# VH - Key Vault Lookup
#--------------------------------------------------------------

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
  provider              = azurerm.private-endpoint-dns
  name                  = "privatelink.blob.core.windows.net"
  resource_group_name   = "core-infra-intsvc-rg"
}

resource "azurerm_key_vault_secret" "wowza-ssh-key" {
  name         = "vh-wowza-${var.environment}-key"
  value        = var.admin_ssh_key_path
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
  # FromTFSec
  content_type     = "secret"
}


#data "azurerm_private_dns_zone" "reform-hearings-dns" {
#  provider              = azurerm.hearings-dns
#  name                  = "hearings.reform.hmcts.net"
#  resource_group_name   = "vh-hearings-reform-hmcts-net-dns-zone"
#}

module "wowza" {
  source                         = "./modules/wowza"
  environment                    = var.environment
  location                       = var.location
  service_name                   = "vh-infra-wowza-${var.environment}"
  admin_ssh_key_path             = var.admin_ssh_key_path
  service_certificate_kv_url     = var.service_certificate_kv_url
  service_certificate_thumbprint = var.service_certificate_thumbprint
  key_vault_id                   = data.azurerm_key_vault.vh-infra-core.id
  address_space                  = lookup(var.workspace_to_address_space_map, var.environment, "")
  storage_msi_client_id          = lookup(var.workspace_to_storage_msi_map, var.environment, "")
  private_dns_zone_group         = data.azurerm_private_dns_zone.core-infra-intsvc.id
  tags = local.common_tags

  #private_dns_zone_group         = data.azurerm_private_dns_zone.core-infra-intsvc.id
  #hearings_dns_zone              = data.azurerm_private_dns_zone.reform-hearings-dns.id
}

#provider "azurerm" {
#  alias = "private-endpoint-dns"
#  features {}
#  hearings_dns_zone              = data.azurerm_private_dns_zone.hearings-dns.name
#  private_dns_zone_group         = data.azurerm_private_dns_zone.core-infra-intsvc.id
#  #hearings_dns_zone              = data.azurerm_private_dns_zone.reform-hearings-dns.name
#}

# resource "azurerm_dns_a_record" "wowza" {
#   provider = azurerm.dns

#   name                = "vh-infra-wowza-${var.environment}"
#   zone_name           = var.dns_zone_name
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   records             = [module.wowza.public_ip_address]
# }
