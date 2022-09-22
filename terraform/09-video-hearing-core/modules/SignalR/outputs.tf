output "signalr_id" {
  value = data.azurerm_signalr_service.signalR.id
}

output "name" {
  value = data.azurerm_signalr_service.signalR.name
}

output "connection_string" {
  value = data.azurerm_signalr_service.signalR.primary_connection_string
}