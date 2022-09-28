resource "azurerm_application_insights" "vh-infra-core" {
  name = var.resource_prefix

  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.resource_prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_monitor_action_group" "this" {

  name                = "VhCriticalAlertsAction-${var.env}"
  resource_group_name = var.resource_group_name
  short_name          = "vhp1action"

  dynamic "email_receiver" {
    for_each = var.email_alerts
    content {
      name          = email_receiver.value.name
      email_address = email_receiver.value.email
    }
  }
  tags = var.tags
}


resource "azurerm_monitor_scheduled_query_rules_alert_v2" "pexip" {
  name                = "vh-pexip-issues-${var.env}"
  description         = "Video Hearings ${var.env} Pexip Issues Monitoring"
  display_name        = "vh-pexip-issues-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_application_insights.vh-infra-core.id]
  severity             = 0
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

  auto_mitigation_enabled          = true
  workspace_alerts_storage_enabled = false
  enabled                          = true
  skip_query_validation            = true

  action {
    action_groups = [azurerm_monitor_action_group.this.id]

  }

  tags = var.tags
}