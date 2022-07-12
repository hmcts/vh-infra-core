output "server_id" {
  value = azurerm_mssql_server.vh-infra-core.id
}

output "name" {
  value = azurerm_mssql_server.vh-infra-core.name
}

output "admin_password" {
  value = random_password.sqlpass.result
}

output "admin_username" {
  value = azurerm_mssql_server.vh-infra-core.administrator_login
}

output "bookings_api_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhbookings;Persist Security Info=False;User ID=${azurerm_mssql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
output "video_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhvideo;Persist Security Info=False;User ID=${azurerm_mssql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
output "notification_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhnotification;Persist Security Info=False;User ID=${azurerm_mssql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
output "test_api_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhtest;Persist Security Info=False;User ID=${azurerm_mssql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
output "service_bus_connection_string" {
  value = azurerm_servicebus_namespace.vh-infra-core.default_primary_connection_string
}
output "video_api_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.vh-infra-core.name}.database.windows.net,1433;Initial Catalog=vhvideo;Persist Security Info=False;User ID=${azurerm_mssql_server.vh-infra-core.administrator_login};Password=${random_password.sqlpass.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}