output "connection_string" {
  value = azurerm_app_configuration.vh.primary_write_key[0].connection_string
}