output "signalr_id" {
  value = jsondecode(azapi_resource.signalR.output).resource_id
}

output "name" {
  value = jsondecode(azapi_resource.signalR.output).name
}

output "connection_string" {
  value = jsondecode(azapi_resource.signalR.output).connection_string
}