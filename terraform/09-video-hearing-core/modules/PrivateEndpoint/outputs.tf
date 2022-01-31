output "endpoint_resource" {
  value = tomap({
    for k, e in azurerm_private_endpoint.vh_endpoint : k => {
      resource_id   = e.id
      resource_name = e.name
      resource_type = k.private_service_connection.subresource_names
      ip_address    = k.private_service_connection[0].private_ip_address
    }
  })
}
