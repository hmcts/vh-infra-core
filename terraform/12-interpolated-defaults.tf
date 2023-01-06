data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

locals {
  common_tags = module.ctags.common_tags
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = lower(var.environment)
  product     = var.product
  builtFrom   = var.builtFrom
}


data "azurerm_private_dns_zone" "sql" {
  provider = azurerm.private-endpoint-dns

  name                = lookup(local.dns_zone_mapping, "sqlServer")
  resource_group_name = local.dns_zone_resource_group_name
}
data "azurerm_private_dns_zone" "redis" {
  provider = azurerm.private-endpoint-dns

  name                = lookup(local.dns_zone_mapping, "redisCache")
  resource_group_name = local.dns_zone_resource_group_name
}
data "azurerm_private_dns_zone" "signalr" {
  provider = azurerm.private-endpoint-dns

  name                = lookup(local.dns_zone_mapping, "signalr")
  resource_group_name = local.dns_zone_resource_group_name
}
data "azurerm_private_dns_zone" "kv" {
  provider = azurerm.private-endpoint-dns

  name                = lookup(local.dns_zone_mapping, "vault")
  resource_group_name = local.dns_zone_resource_group_name
}