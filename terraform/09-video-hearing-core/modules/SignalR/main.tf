locals {
  sku_name = "Premium_P1"
  sku_type = "Premium"
  sku_size = "P1"
}

resource "azapi_resource" "signalR" {
  type      = "Microsoft.SignalRService/signalR@2022-02-01"
  name      = var.name
  location  = var.location
  parent_id = var.resource_group_id

  identity {
    type         = "UserAssigned"
    identity_ids = var.managed_identities
  }

  body = jsonencode({
    properties = {
      cors = {
        allowedOrigins = [
          "*"
        ]
      }
    }
    sku = {
      capacity = 1
      name     = local.sku_name
      tier     = local.sku_type
    }
    kind = "SignalR"
  })
  
  tags      = var.tags
}

# resource "azapi_resource" "signalr_custom_domain" {
#   type      = "Microsoft.SignalRService/signalR/customDomains@2022-02-01"
#   name      = "signalr_custom_domain"
#   parent_id = azapi_resource.signalR.id
#   body = jsonencode({
#     properties = {
#       customCertificate = {
#         id = var.signalr_custom_certificate_id
#       }
#       domainName = var.signalr_custom_domain
#     }
#   })
# }

# resource "azapi_resource" "signalr_custom_certificate" {
#   type      = "Microsoft.SignalRService/signalR/customCertificates@2022-02-01"
#   name      = "signalr_custom_certificate"
#   parent_id = azapi_resource.signalR.id
#   body = jsonencode({
#     properties = {
#       keyVaultBaseUri       = "string"
#       keyVaultSecretName    = "string"
#       keyVaultSecretVersion = "string"
#     }
#   })
# }

data "azurerm_signalr_service" "signalR" {
  name                = var.name
  resource_group_name = var.resource_group_name
  depends_on = [
    azapi_resource.signalR
  ]
}