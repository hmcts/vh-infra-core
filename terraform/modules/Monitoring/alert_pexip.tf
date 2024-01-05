
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "pexip" {
  count = var.env == "prod" ? 1 : 0

  name                = "VH - SDS - Pexip Issues ${title(var.env)}"
  display_name        = "VH - SDS - Pexip Issues ${title(var.env)}"
  description         = "If there are multiple Pexip errors in the logs this alert fires. Assuming all availabilty checks are ok this needs to be raised urgently with Kinly"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [module.application_insights.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      traces
        | where operation_Name contains "waiting-room"
        | where message contains "pexip error" or message contains "Error from pexip."
      QUERY
    time_aggregation_method = "Count"
    threshold               = 6
    operator                = "GreaterThan"


    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  enabled                          = true
  skip_query_validation            = true

  action {
    action_groups = concat(
      [azurerm_monitor_action_group.this["dev"].id, azurerm_monitor_action_group.this["devops"].id],
      (var.env == "prod" ? [azurerm_monitor_action_group.this["kinly"].id, azurerm_monitor_action_group.action_group_pexip[0].id] : [])
    )

  }

  tags = var.tags
}

resource "azurerm_automation_webhook" "webhook_pexip" {
  count = var.env == "prod" ? 1 : 0

  name                    = "VH - SDS - Pexip Issues ${title(var.env)}"
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  expiry_time             = "2028-12-31T00:00:00Z"
  enabled                 = true
  runbook_name            = var.dynatrace_runbook_name

  parameters = {
    dynatracetenant  = var.dynatrace_tenant
    credentialname   = "Dynatrace-Token"
    alertname        = "VH - SDS - Pexip Issues ${title(var.env)}"
    alertdescription = "If there are multiple Pexip errors in the logs this alert fires. Assuming all availabilty checks are ok this needs to be raised urgently with Kinly"
    entitytype       = "CLOUD_APPLICATION"
    entityname       = "vh-video-web"
    eventype         = "ERROR_EVENT"
  }
}

resource "azurerm_monitor_action_group" "action_group_pexip" {
  count = var.env == "prod" ? 1 : 0

  name                = "VH - SDS - Pexip Issues ${title(var.env)}"
  short_name          = "PexipIssues"
  resource_group_name = var.resource_group_name

  automation_runbook_receiver {
    name                    = "VH - SDS - Pexip Issues ${title(var.env)}"
    automation_account_id   = var.automation_account_id
    runbook_name            = var.dynatrace_runbook_name
    webhook_resource_id     = azurerm_automation_webhook.webhook_pexip[0].id
    is_global_runbook       = true
    service_uri             = azurerm_automation_webhook.webhook_pexip[0].uri
    use_common_alert_schema = false
  }

  tags = var.tags
}
