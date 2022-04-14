output "signalr_id" {
  value = azurerm_signalr_service.vh.id
}

output "name" {
  value = azurerm_signalr_service.vh.name
}

output "connection_string" {
  value = azurerm_signalr_service.vh.primary_connection_string
}