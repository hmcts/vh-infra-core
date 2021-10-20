provider "azurerm" {
  version = ">=2.64.0"
  features {}
}

#provider "azurerm" {
#  features {}
#  alias           = "private-endpoint-dns"
#  skip_provider_registration = "true"
#  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
#} 