output "instrumentation_key" {
  value = azurerm_application_insights.vh-infra-core.instrumentation_key
}

output "ai_connectionstring" {
  value = azurerm_application_insights.vh-infra-core.connection_string
}