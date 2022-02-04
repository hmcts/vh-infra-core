locals {
  # for sandbox testing move to tfvars
  # Year-Month-Day'T'HH:MM:SS:Z
  schedule_action = {
    vmstart = { time = "2022-04-02T10:00:00Z", action = "Start"},
    vmstop  = { time = "2022-04-02T09:00:00Z", action = "Stop"}
  }
}


# provision our runbook:
resource "azurerm_automation_runbook" "wowza-VM-runbook" {
  name                    = "wowza-VM-runbook-${var.environment}"
  location                = var.location
  resource_group_name     = azurerm_resource_group.wowza.name
  automation_account_name = azurerm_resource_group_template_deployment.wowza-automation-acct.name
  log_verbose             = "false"
  log_progress            = "false"
  description             = "This is a runbook used to stop and start wowza VMs"
  runbook_type            = "PowerShellWorkflow"
  content                 = "./VM-Automation-Files/wowza-vm-runbook.ps1"
  publish_content_link {
    uri = ""
  }
  depends_on = [
    azurerm_resource_group_template_deployment.wowza-automation-acct
  ]
}

resource "azurerm_automation_schedule" "wowza-automation-schedule" {
  for_each                = local.schedule_action
  name                    = "wowza-${each.value.action}-schedule-${var.environment}"
  resource_group_name     = azurerm_resource_group.wowza.name
  automation_account_name = azurerm_resource_group_template_deployment.wowza-automation-acct.name # "wowza-automation-acct-${var.environment}"
  frequency               = "Day"
  interval                = 1
  timezone                = "Europe/London"

  start_time              = each.value.time
  description             = "This is a schedule to ${each.value.action} wowza VMs at ${each.value.time}"
  depends_on = [
    azurerm_resource_group_template_deployment.wowza-automation-acct
  ]
}

resource "azurerm_automation_job_schedule" "runbook-schedule-job" {
  for_each                = local.schedule_action
  resource_group_name     = azurerm_resource_group.wowza.name
  automation_account_name = "wowza-automation-acct-${var.environment}"
  schedule_name           = "wowza-${each.value.action}-schedule-${var.environment}"
  runbook_name            = "wowza-VM-runbook-${var.environment}"

# vmlist = azurerm_linux_virtual_machine.wowza[*].name
  parameters = {
    mi_principal_id       = azurerm_user_assigned_identity.wowza-automation-account-mi.principal_id
    vmname                = join(",", azurerm_linux_virtual_machine.wowza[*].name)
    resourcegroup         = azurerm_resource_group.wowza.name
    action                = each.value.action
  }
}