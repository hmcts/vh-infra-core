output "kvuser" {
  value = azurerm_user_assigned_identity.kvuser
}


output "keyvault_id" {
  value = azurerm_key_vault.vh-infra-core-ht.id
}

output "app_keyvaults_out" {
  value = azurerm_key_vault.app_keyvaults
}
