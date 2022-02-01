terraform {
  required_version = ">= 1.0.0"

  #backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.64.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 0.6"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "REPLACE_ME"
}

provider "azurerm" {
  alias = "dns"

  features {}
  tenant_id     = var.dns_tenant_id
  client_id     = var.dns_client_id
  client_secret = var.dns_client_secret

  subscription_id = var.dns_subscription_id
}

provider "azuread" {
  #version = "~> 0.6"

  alias = "vh"

  tenant_id     = var.vh_tenant_id
  client_id     = var.vh_client_id
  client_secret = var.vh_client_secret

  subscription_id = "not needed"

}

provider "azuread" {
  #version = "~> 0.6"

  alias = "infra"
}
