
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "wowza_reconcile" {
  name                = "vh-wowza-reconcile-issues-${var.env}"
  description         = "Video Hearings ${var.env} Reconciles expected hearing recordings against those in blob storage at 22:00 daily"
  display_name        = "vh-wowza-reconcile-issues-${var.env}"
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

resource "azurerm_monitor_scheduled_query_rules_alert" "wowza_missing" {
  name                = "vh-wowza-missing-recordings-issues-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  action {
    action_group = [azurerm_monitor_action_group.this["dev"].id, azurerm_monitor_action_group.this["devops"].id]
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

data "azurerm_lb" "wowza_lb_private" {
  name                = "vh-infra-wowza-${var.env}"
  resource_group_name = "vh-infra-wowza-${var.env}"
}

data "azurerm_lb" "wowza_lb_public"{
  name                = "vh-infra-wowza-${var.env}"
  resource_group_name = "vh-infra-wowza-${var.env}-public"
}

locals {
  wowzaLoadBalancers = {
    private = {
      scope = [data.azurerm_lb.wowza_lb_private.id]
      name  = "vh-wowza-lb-private-alert-"
    }
    public = {
      scope = [data.azurerm_lb.wowza_lb_public.id]
      name  = "vh-wowza-lb-public-alert-"
    }
  }
}

resource "azurerm_monitor_metric_alert" "wowza_lb_alert"{
  for_each = local.wowzaLoadBalancers

  name                = "${each.value.name}${var.env}"
  resource_group_name = var.resource_group_name
  scopes              = each.value.scope
  description         = "Wowza Load balancer reports that the Health Check is below 95%. This may impact the service. Please investigate ASAP."

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 95
  }

  severity                = 1
  frequency               = 5
  window_size             = 5

  action {
    action_group_id  = azurerm_monitor_action_group.this["dev"].id 
  }

  action {
    action_group_id = azurerm_monitor_action_group.this["devops"].id
  }
}