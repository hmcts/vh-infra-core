output "endpoint_resource" {
  value = tomap({
    for k, e in azurerm_private_endpoint.vh_endpoint : k => {
      resource_id   = e.id
      name          = e.name
      resource_type = k.private_service_connection.subresource_names
      value         = k.private_service_connection[0]
    }
  })
}
