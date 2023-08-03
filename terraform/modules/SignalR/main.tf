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
      features = [
          {
            serviceMode = "Default"
          }
        ],
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

  ignore_casing = true
  
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

# resource "azurerm_monitor_diagnostic_setting" "signalR_diag" {
#   name                 = var.name
#   target_resource_id   = data.azurerm_signalr_service.signalR.id
#   partner_solution_id = 
#   eventhub_authorization_rule_id =
#   storage_account_id =  

#   log {
#     category = "AllLogs"
#     enabled  = true

#     retention_policy {
#       enabled = false
#     }
#   }

#   metric {
#     category = "AllMetrics"
#     enabled  = true

#     retention_policy {
#       enabled = false
#     }
#   }
  
# }