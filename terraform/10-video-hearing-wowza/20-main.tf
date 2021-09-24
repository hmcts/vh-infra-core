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
  tags = local.common_tags
}

provider "azurerm" {
  alias = "private-endpoint-dns"
  features {}
}

# resource "azurerm_dns_a_record" "wowza" {
#   provider = azurerm.dns

#   name                = "vh-infra-wowza-${var.environment}"
#   zone_name           = var.dns_zone_name
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   records             = [module.wowza.public_ip_address]
# }
