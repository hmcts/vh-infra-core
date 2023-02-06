
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "wowza_reconcile" {
  count = var.env == "prod" ? 1 : 0

  name                = "VH - SDS - Wowza Reconcile Issues ${title(var.env)}"
  display_name        = "VH - SDS - Wowza Reconcile Issues ${title(var.env)}"
  description         = "Video Hearings ${var.env} Reconciles expected hearing recordings against those in blob storage at 22:00 daily"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT6H"
  window_duration      = "PT6H"
  scopes               = [azurerm_application_insights.vh-infra-core.id]
  severity             = 2
  criteria {
    query                   = <<-QUERY
      union traces
        | union exceptions
        | where message contains "missing wowza audio or empty files for conferences"
        | where cloud_RoleName contains "vh-scheduler-jobs"
        | order by timestamp asc
      QUERY
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = true
  workspace_alerts_storage_enabled = false
  enabled                          = true
  skip_query_validation            = true

  action {
    action_groups = [azurerm_monitor_action_group.this["dev"].id, azurerm_monitor_action_group.this["devops"].id]

  }

  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert" "wowza_not_recording" {
  count = var.env == "prod" ? 1 : 0

  name                = "VH - SDS - Wowza Stream Not Recording ${title(var.env)}"
  resource_group_name = var.resource_group_name
  location            = var.location

  action {
    action_group = [azurerm_monitor_action_group.this["dev"].id, azurerm_monitor_action_group.this["devops"].id, azurerm_monitor_action_group.action_group_wowza_not_recording[0].id]
  }

  data_source_id = azurerm_application_insights.vh-infra-core.id
  description    = "The message \"[Judge WR] - Should not continue without a recording. Show alert\" has been seen multiple times in the last 48 hours. This likely means recordings are failing, if everything else appears good check the connectivity between Pexip (Kinly) and wowza"
  enabled        = true

  query = <<-QUERY
    // All telemetry for Operation ID: 1892873df8b941eb8b350946db9ed680
    traces
    // Apply filters
    | where message contains "should not continue without a recording. "
  QUERY

  severity                = 3
  frequency               = 5
  time_window             = 5
  auto_mitigation_enabled = true

  trigger {
    operator  = "GreaterThan"
    threshold = 30
  }

  tags = var.tags
}


resource "azurerm_automation_webhook" "webhook_wowza_not_recording" {
  count = var.env == "prod" ? 1 : 0

  name                    = "VH - SDS - Wowza Stream Not Recording ${title(var.env)}"
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  expiry_time             = "2028-12-31T00:00:00Z"
  enabled                 = true
  runbook_name            = var.dynatrace_runbook_name

  parameters = {
    dynatracetenant  = var.dynatrace_tenant
    credentialname   = "Dynatrace-Token"
    alertname        = "VH - SDS - Wowza Stream Not Recording ${title(var.env)}"
    alertdescription = "The message \"[Judge WR] - Should not continue without a recording. Show alert\" has been seen multiple times in the last 48 hours. This likely means recordings are failing, if everything else appears good check the connectivity between Pexip (Kinly) and wowza"
    entitytype       = "CLOUD_APPLICATION"
    entityname       = "vh-video-web"
    eventype         = "ERROR_EVENT"
  }
}

resource "azurerm_monitor_action_group" "action_group_wowza_not_recording" {
  count = var.env == "prod" ? 1 : 0

  name                = "VH - SDS - Wowza Stream Not Recording ${title(var.env)}"
  short_name          = "WowzaIssues"
  resource_group_name = var.resource_group_name

  automation_runbook_receiver {
    name                    = "VH - SDS - Wowza Stream Not Recording ${title(var.env)}"
    automation_account_id   = var.automation_account_id
    runbook_name            = var.dynatrace_runbook_name
    webhook_resource_id     = azurerm_automation_webhook.webhook_wowza_not_recording[0].id
    is_global_runbook       = true
    service_uri             = azurerm_automation_webhook.webhook_wowza_not_recording[0].uri
    use_common_alert_schema = false
  }

  tags = var.tags
}