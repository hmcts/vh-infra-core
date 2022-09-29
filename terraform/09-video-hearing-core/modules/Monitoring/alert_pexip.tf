
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "pexip" {
  name                = "vh-pexip-issues-${var.env}"
  description         = "If there are multiple Pexip errors in the logs this alert fires. Assuming all availabilty checks are ok this needs to be raised urgently with Kinly"
  display_name        = "vh-pexip-issues-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_application_insights.vh-infra-core.id]
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
      (var.env == "prod" ? [azurerm_monitor_action_group.this["kinly"].id] : [])
    )

  }

  tags = var.tags
}