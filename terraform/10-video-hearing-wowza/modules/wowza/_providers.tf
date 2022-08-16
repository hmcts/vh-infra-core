provider "azurerm" {
  features {}
}

provider "azurerm" { ## TODO: delete after first run. needs to be left in to remove tf state reference
  features {}
  alias           = "peering_target"
  subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}

provider "azurerm" {
  features {}
  alias           = "peering_target_prod"
  subscription_id = local.peering_prod_subscription
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "peering_target_nonprod"
  subscription_id = local.peering_nonprod_subscription
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "peering_target_vpn"
  subscription_id = local.peering_vpn_subscription
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
  alias                      = "private-endpoint-dns"
  skip_provider_registration = "true"
  subscription_id            = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

# provider "azurerm" {
#   alias = "soc"
#   features {}
#   subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
#   client_id       = var.splunk_client_id
#   client_secret   = var.splunk_client_secret
#   tenant_id       = var.splunk_tenant_id
# }