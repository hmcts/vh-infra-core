output "endpoint_resource" {
  value = tomap({
    for k, v in azurerm_private_endpoint.vh_endpoint : k => {
      resource_id   = v.id
      resource_name = v.name
      resource_type = v.private_service_connection[0].subresource_names[0]
      resource_ip   = v.private_service_connection[0].private_ip_address
    }
  })
}