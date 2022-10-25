
resource "azurerm_automation_account" "vm-start-stop" {

  name                = "vh-wowza-${var.environment}-aa"
  location            = var.location
  resource_group_name = azurerm_resource_group.wowza.name
  sku_name            = "Basic"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.wowza-automation-account-mi.id]
  }

  tags = var.tags
}

# module "vm_automation" {
#   source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

#   product                 = "vh-wowza"
#   env                     = var.environment
#   location                = var.location
#   automation_account_name = azurerm_automation_account.vm-start-stop.name
#   tags                    = var.tags
#   schedules               = var.schedules
#   resource_group_name     = azurerm_resource_group.wowza.name
#   vm_names = [
#     for wowza_vm in azurerm_linux_virtual_machine.wowza : wowza_vm.name
#   ]
#   mi_principal_id = azurerm_user_assigned_identity.wowza-automation-account-mi.principal_id
# }