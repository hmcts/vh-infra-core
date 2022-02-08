locals {

  runbook_name = "wowza-vm-runbook.ps1"
  runbook_content = file("./VM-Automation-Files/${local.runbook_name}")
  # Move to tfvars?
  day      = timestamp()
  start_date = formatdate("YYYY-MM-DD", local.day)
  start_time = "14:45:00" # test values only
  stop_time  = "14:55:00" # test values only


  schedule_action = {
    vmstart = { time = "${local.start_date}T${local.start_time}Z", action = "Start"},
    vmstop  = { time = "${local.start_date}T${local.stop_time}Z", action = "Stop"}
  }
}


# provision our runbook:
resource "azurerm_automation_runbook" "wowza-VM-runbook" {
  name                    = "wowza-VM-runbook-${var.environment}"
  location                = var.location
  resource_group_name     = azurerm_resource_group.wowza.name
  automation_account_name = azurerm_resource_group_template_deployment.wowza-automation-acct.name
  log_verbose             = var.environment == "prod" ? "false" : "true"
  log_progress            = "true"
  description             = "This is a runbook used to stop and start wowza VMs"
  runbook_type            = "PowerShell"
  content                 = local.runbook_content
  publish_content_link {
    uri = "https://raw.githubusercontent.com/hmcts/vh-shared-infrastructure/VIH-8562-Wowza-MI-Automation/terraform/10-video-hearing-wowza/VM-Automation-Files/wowza-vm-runbook.ps1"
  }
  tags                     = var.tags



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
  runbook_name            = azurerm_automation_runbook.wowza-VM-runbook.name

# vmlist = azurerm_linux_virtual_machine.wowza[*].name
  parameters = {
    mi_principal_id       = azurerm_user_assigned_identity.wowza-automation-account-mi.principal_id
    vmlist                = join(",", azurerm_linux_virtual_machine.wowza[*].name)
    resourcegroup         = azurerm_resource_group.wowza.name
    action                = each.value.action
  }
}