locals {
  scheduler_jobs_name = "vh-scheduler-jobs"
  cron_jobs = {
    "AnonymiseHearingsConferencesAndDeleteAadUsersFunction" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
    "ClearConferenceInstantMessageHistory" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
    "ClearHearingsFunction" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
    "DeleteAudiorecordingApplicationsFunction" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
    "GetJudiciaryUsersFunction" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
    "ReconcileHearingAudioWithStorageFunction" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
    "RemoveHeartbeatsForConferencesFunction" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
    "SendHearingNotificationsFunction" = {
      "job_name"  = local.scheduler_jobs_name
      "threshold" = 0
      "severity"  = 2
    }
  }
}


resource "azurerm_monitor_scheduled_query_rules_alert_v2" "cron_jobs" {
  for_each = local.cron_jobs

  name                = "vh-cron-${each.value.job_name}-${each.key}-issues-${var.env}"
  description         = "The job ${each.key} in ${each.value.job_name} ${var.env} has had failures in the last day. Please investigate ASAP as it may impact the service."
  display_name        = "vh-cron-${each.value.job_name}-${each.key}-issues-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT6H"
  window_duration      = "PT6H"
  scopes               = [azurerm_application_insights.vh-infra-core.id]
  severity             = each.value.severity
  criteria {
    query                   = <<-QUERY
      requests
        | project
            timestamp,
            id,
            cloud_RoleName,
            operation_Name,
            success,
            resultCode
        | where timestamp > ago(1d)
        | where cloud_RoleName =~ '${each.value.job_name}' and operation_Name =~ '${each.key}'
        | where success == 'False'
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
