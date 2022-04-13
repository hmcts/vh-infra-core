resource "azurerm_application_insights" "vh-infra-core" {
  name = var.resource_prefix

  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.resource_prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
