terraform {
  required_version = ">= 1.0.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.20.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.26.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "= 0.6.0"
    }
  }
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "dns"

  features {}
  tenant_id     = var.dns_tenant_id
  client_id     = var.dns_client_id
  client_secret = var.dns_client_secret

  subscription_id = var.dns_subscription_id
}

provider "azurerm" {
  features {}
  alias                      = "private-endpoint-dns"
  skip_provider_registration = "true"
  subscription_id            = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}


provider "azuread" {
  #version = "~> 0.6"

  alias = "vh"

  tenant_id     = var.vh_tenant_id
  client_id     = var.vh_client_id
  client_secret = var.vh_client_secret
}

provider "azuread" {
  #version = "~> 0.6"

  alias = "infra"
}

provider "azurerm" {
  features {}
  alias           = "cvp"
  subscription_id = var.cvp_subscription_id
  client_id       = var.cvp_client_id
  client_secret   = var.cvp_client_secret
  tenant_id       = data.azurerm_client_config.current.tenant_id
}