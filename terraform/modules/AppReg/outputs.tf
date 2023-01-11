output "app_registrations" {
  value = azuread_application.app_reg
}

output "app_passwords" {
  value = azuread_application_password.create_secret
}

output "output_keyvault" {
  value = data.azurerm_key_vault.key_vault
}