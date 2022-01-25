terraform {
  required_version = ">= 1.0.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.64.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "REPLACE_ME"
}

provider "azurerm" {
  alias   = "dns"
  features {}
  #tenant_id     = var.dns_tenant_id
  #client_id     = var.dns_client_id
  #client_secret = var.dns_client_secret
#
  #subscription_id = var.dns_subscription_id
}

#provider "azurerm" {
#  features {}
#  alias           = "private-endpoint-dns"
#  skip_provider_registration = "true"
#  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
#}


provider "azurerm" {
  features {}
  alias           = "hearings-dns"
  skip_provider_registration = "true"
  subscription_id = "4bb049c8-33f3-4860-91b4-9ee45375cc18"
}

provider "azurerm" {
  features {}
  alias           = "peering_target"
  subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}

provider "azurerm" {
  features {}
  alias           = "peering_client"
  subscription_id = data.azurerm_client_config.current.subscription_id
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}