
## Loop secrets
resource "azurerm_key_vault_secret" "secret" {
  for_each        = { for secret in var.secrets : "${secret.name}-${var.key_vault_name}-secret" => secret }
  key_vault_id    = var.key_vault_id
  name            = each.value.name
  value           = each.value.value
  tags            = merge(var.tags, each.value.tags)
  content_type    = each.value.content_type
  expiration_date = "2032-12-31T00:00:00Z"
}
