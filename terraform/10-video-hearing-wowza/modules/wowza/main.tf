resource "azurerm_resource_group" "wowza" {
  name     = var.service_name
  location = var.location
  tags     = var.tags
}

data "azurerm_log_analytics_workspace" "core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = "vh-infra-core-${var.environment}"
}