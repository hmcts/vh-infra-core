locals {
  sku_name = "Premium_P1"
  sku_type = "Premium"
  sku_size = "P1"
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azapi_resource" "signalR" {
  type      = "Microsoft.SignalRService/signalR@2022-02-01"
  name      = var.name
  location  = data.azurerm_resource_group.resource_group.location
  parent_id = data.azurerm_resource_group.resource_group.id

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

  tags = var.tags
}

resource "azapi_resource" "signalr_custom_domain" {
  type      = "Microsoft.SignalRService/signalR/customDomains@2022-02-01"
  name      = var.custom_domain_name
  parent_id = azapi_resource.signalR.id

  body = jsonencode({
    properties = {
      customCertificate = {
        id = azapi_resource.signalr_custom_certificate.id
      }
      domainName = var.custom_domain_name
    }
  })
  depends_on = [
    azapi_resource.signalr_custom_certificate
  ]
}

resource "azapi_resource" "signalr_custom_certificate" {
  type      = "Microsoft.SignalRService/signalR/customCertificates@2022-02-01"
  name      = var.key_vault_cert_name
  parent_id = azapi_resource.signalR.id

  body = jsonencode({
    properties = {
      keyVaultBaseUri    = var.key_vault_uri
      keyVaultSecretName = var.key_vault_cert_name
    }
  })
}

data "azurerm_signalr_service" "signalR" {
  name                = var.name
  resource_group_name = var.resource_group_name
  depends_on = [
    azapi_resource.signalR
  ]
}