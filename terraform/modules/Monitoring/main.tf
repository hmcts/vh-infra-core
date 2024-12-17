module "application_insights" {
  source = "git::https://github.com/hmcts/terraform-module-application-insights.git?ref=4.x"


  env                 = var.env
  product             = var.product
  location            = var.location
  override_name       = var.resource_prefix
  resource_group_name = var.resource_group_name

  common_tags = var.tags
}

# moved {
#   from = azurerm_application_insights.vh-infra-core
#   to   = module.application_insights.azurerm_application_insights.this
# }

resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.resource_prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
