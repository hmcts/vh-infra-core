provider "azurerm" {
  version = ">=2.64.0"
  features {}
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
provider "azurerm" {
  features {}
  alias           = "private-endpoint-dns"
  skip_provider_registration = "true"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
} 