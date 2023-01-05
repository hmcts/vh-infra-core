
resource "azurerm_media_services_account" "vh-infra-core" {
  name                = replace(var.resource_prefix, "-", "")
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account {
    id         = var.storage_account_id
    is_primary = true
  }
  tags = var.tags
}
