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
