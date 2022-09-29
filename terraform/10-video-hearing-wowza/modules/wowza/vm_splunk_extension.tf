locals {
  splunk_admin_username = "splunkadmin"
}

resource "random_password" "splunk_admin_password" {
  length           = 32
  special          = true
  override_special = "_%*"
}

module "splunk-uf" {
  count = length(azurerm_linux_virtual_machine.wowza)

  source = "git::https://github.com/hmcts/terraform-module-splunk-universal-forwarder.git?ref=master"

  auto_upgrade_minor_version = true

  virtual_machine_type = "vm"
  virtual_machine_id   = azurerm_linux_virtual_machine.wowza[count.index].id

  splunk_username = local.splunk_admin_username
  splunk_password = random_password.splunk_admin_password.result

  tags = var.tags

}
