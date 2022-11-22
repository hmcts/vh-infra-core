locals {
  cron_jobs = {
    "vh-anonymise-hearings-and-conferences-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-clear-conference-message-history-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-clear-hearings-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-delete-audio-recording-applications-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-get-judiciary-users-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-reconcile-hearing-audio-with-storage-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-remove-heartbeats-for-conferences-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-send-hearing-notifications-job" = {
      "threshold" = 0
      "severity"  = 2
    }
    "vh-hearing-allocations-job" = {
      "threshold" = 0
      "severity"  = 2
    }
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "cron_jobs" {
  for_each = var.env == "prod" ? local.cron_jobs : {}

  name                = "vh-cron-${each.key}-issues-${var.env}"
  description         = "The job ${each.key} in ${var.env} has had failures in the last day. Please investigate ASAP as it may impact the service."
  display_name        = "vh-cron-${each.key}-issues-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT6H"
  window_duration      = "PT6H"
  scopes               = [azurerm_application_insights.vh-infra-core.id]
  severity             = each.value.severity
  criteria {
    query                   = <<-QUERY
      exceptions 
        | where cloud_RoleInstance like '${each.key}'
        | where timestamp > ago(1d)
        | order by timestamp desc
      QUERY
    time_aggregation_method = "Count"
    threshold               = each.value.threshold
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
