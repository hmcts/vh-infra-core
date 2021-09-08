terraform {
  required_version = ">= 1.0.0"

  backend "azurerm" {
    subscription_id  = "04d27a32-7a07-48b3-95b8-3c8691e1a263"
    storage_account_name="ca8140a9e09e2ee23f7absa"
    key="UK South/application/sbox/09-video-hearing-core/terraform.tfstate"
    container_name="subscription-tfstate"
    resource_group_name="azure-control-SBOX-rg"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.64.0"
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
  tenant_id     = var.dns_tenant_id
  client_id     = var.dns_client_id
  client_secret = var.dns_client_secret

  subscription_id = var.dns_subscription_id
}

provider "azuread" {
  version = "~> 0.6"

  alias = "vh"

  tenant_id     = var.vh_tenant_id
  client_id     = var.vh_client_id
  client_secret = var.vh_client_secret

  subscription_id = "not needed"

}

provider "azuread" {
  version = "~> 0.6"

  alias = "infra"
}
