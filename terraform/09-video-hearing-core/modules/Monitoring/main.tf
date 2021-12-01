data "azurerm_key_vault" "vh-infra-core-kv" {
  name                = var.resource_group_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_application_insights" "vh-infra-core" {
  name                = var.resource_prefix

  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.resource_prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

output "instrumentation_key" {
  value = azurerm_application_insights.vh-infra-core.instrumentation_key
}

resource "azurerm_key_vault_secret" "applicationinsights" {
  name         = "applicationinsights--instrumentationkey"
  value        = azurerm_application_insights.vh-infra-core.instrumentation_key
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  tags = var.tags
}

resource "azurerm_key_vault_secret" "appinsightskey" {
  name         = "azuread--appinsightskey"
  value        = azurerm_application_insights.vh-infra-core.instrumentation_key
  key_vault_id = data.azurerm_key_vault.vh-infra-core-kv.id
  tags = var.tags
}



