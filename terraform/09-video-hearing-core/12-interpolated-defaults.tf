data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

locals {
  common_tags = module.ctags.common_tags

  variable "dns_zone_mapping" {
  description = "mapping for endpoint dns"
  default = {
    "sqlServer" = "privatelink.database.windows.net",
    "redisCache" = "privatelink.redis.cache.windows.net",
    "signalr" = "privatelink.service.signalr.net",
    "vault" = "privatelink.vaultcore.azure.net"

  }
}
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = lower(var.environment)
  product     = var.product
  builtFrom   = var.builtFrom
}
