output "kvuser" {
  value = azurerm_user_assigned_identity.kvuser
}


output "keyvault_id" {
  value = azurerm_key_vault.vh-infra-core-ht.id
}

output "keyvault_name" {
  value = azurerm_key_vault.vh-infra-core-ht.name
}

output "keyvaults_ids"{
  value = tomap({
    for k,v in azurerm_key_vault.app_keyvaults : k => v.id
  })
}

output "keyvaults_names" {
  value = tomap({
    for k,v in azurerm_key_vault.app_keyvaults : k => v.name
  })
}

output "keyvault_resource" {
  value = tomap({
    for k, v in azurerm_key_vault.app_keyvaults : k => {
      resource_id  = v.id
      resource_name = v.name
      resource_type = "vault"
    }
  })
}

output "app_keyvaults_out" {
  value = azurerm_key_vault.app_keyvaults
}
