# Splunk
variable "install_splunk_uf" {
  default = false
}

data "azurerm_key_vault" "soc_vault" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name                = "soc-prod"
  resource_group_name = "soc-core-infra-prod-rg"
}

data "azurerm_key_vault_secret" "splunk_username" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name         = "splunk-gui-admin-username"
  key_vault_id = data.azurerm_key_vault.soc_vault[0].id
}

data "azurerm_key_vault_secret" "splunk_password" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name         = "splunk-gui-admin-password"
  key_vault_id = data.azurerm_key_vault.soc_vault[0].id
}

data "azurerm_key_vault_secret" "splunk_pass4symmkey" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name         = "Splunk-pass4SymmKey"
  key_vault_id = data.azurerm_key_vault.soc_vault[0].id
}