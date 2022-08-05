module "splunk-uf" {
  for_each                   = azurerm_linux_virtual_machine.wowza
  source                     = "git::https://github.com/hmcts/terraform-module-splunk-universal-forwarder.git?ref=master"
  auto_upgrade_minor_version = true
  virtual_machine_type       = "vm"
  virtual_machine_id         = each.value.id
  splunk_username            = local.splunk_username
  splunk_password            = random_password.splunkPassword.result
  splunk_pass4symmkey        = data.azurerm_key_vault_secret.splunk_pass4symmkey.value
}