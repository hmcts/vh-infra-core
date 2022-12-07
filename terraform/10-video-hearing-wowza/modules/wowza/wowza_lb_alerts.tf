data "azurerm_monitor_action_group" "dev" {
  resource_group_name = "vh-infra-core-${var.environment}"
  name                = "Vh-Action-Group-dev-${var.environment}"
}

data "azurerm_monitor_action_group" "devops" {
  resource_group_name = "vh-infra-core-${var.environment}"
  name                = "Vh-Action-Group-devops-${var.environment}"
}

locals {
  wowzaLoadBalancers = {
    private = {
      scope = [azurerm_lb.wowza.id]
      name  = "vh-wowza-lb-private-alert-${var.environment}"
    }
    public = {
      scope = [azurerm_lb.wowza-public.id]
      name  = "vh-wowza-lb-public-alert-${var.environment}"
    }
  }
}

resource "azurerm_monitor_metric_alert" "wowza_lb_alert" {
  for_each = var.environment == "prod" ? local.wowzaLoadBalancers : {}

  name                = each.value.name
  resource_group_name = azurerm_resource_group.wowza.name
  scopes              = each.value.scope
  description         = "Wowza Load Balancer Health is Below 95%, Please Investigate ASAP as this may impact the service."
  tags                = var.tags
  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 95
  }

  severity    = 2
  frequency   = "PT5M"
  window_size = "PT5M"

  action {
    action_group_id = data.azurerm_monitor_action_group.dev.id
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.devops.id
  }
}