resource "azapi_resource" "symbolicname" {
  type = "Microsoft.SignalRService/signalR@2022-02-01"
  name = "string"
  location = "string"
  parent_id = "string"
  tags = {
    tagName1 = "tagValue1"
    tagName2 = "tagValue2"
  }
  identity {
    type = "string"
    identity_ids = []
  }
  body = jsonencode({
    properties = {
      cors = {
        allowedOrigins = [
          "string"
        ]
      }
      disableAadAuth = bool
      disableLocalAuth = bool
      features = [
        {
          flag = "string"
          properties = {}
          value = "string"
        }
      ]
      liveTraceConfiguration = {
        categories = [
          {
            enabled = "string"
            name = "string"
          }
        ]
        enabled = "string"
      }
      networkACLs = {
        defaultAction = "string"
        privateEndpoints = [
          {
            allow = [
              "string"
            ]
            deny = [
              "string"
            ]
            name = "string"
          }
        ]
        publicNetwork = {
          allow = [
            "string"
          ]
          deny = [
            "string"
          ]
        }
      }
      publicNetworkAccess = "string"
      resourceLogConfiguration = {
        categories = [
          {
            enabled = "string"
            name = "string"
          }
        ]
      }
      tls = {
        clientCertEnabled = bool
      }
      upstream = {
        templates = [
          {
            auth = {
              managedIdentity = {
                resource = "string"
              }
              type = "string"
            }
            categoryPattern = "string"
            eventPattern = "string"
            hubPattern = "string"
            urlTemplate = "string"
          }
        ]
      }
    }
    sku = {
      capacity = int
      name = "string"
      tier = "string"
    }
    kind = "string"
  })
}

resource "azapi_resource" "symbolicname" {
  type = "Microsoft.SignalRService/signalR/customDomains@2022-02-01"
  name = "string"
  parent_id = "string"
  body = jsonencode({
    properties = {
      customCertificate = {
        id = "string"
      }
      domainName = "string"
    }
  })
}

resource "azapi_resource" "symbolicname" {
  type = "Microsoft.SignalRService/signalR/customCertificates@2022-02-01"
  name = "string"
  parent_id = "string"
  body = jsonencode({
    properties = {
      keyVaultBaseUri = "string"
      keyVaultSecretName = "string"
      keyVaultSecretVersion = "string"
    }
  })
}