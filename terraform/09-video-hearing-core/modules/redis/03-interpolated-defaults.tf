data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "vh-infra-core" {
  name = var.resource_group_name
}
