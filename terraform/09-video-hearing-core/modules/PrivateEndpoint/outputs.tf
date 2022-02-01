output "endpoint_resource" {
  value = tomap({
    for k, e in azurerm_private_endpoint.vh_endpoint : k => {
      resource_id   = e.id
      resource_name = e.name
      resource_type = e.private_service_connection.0
    }
  })
}
