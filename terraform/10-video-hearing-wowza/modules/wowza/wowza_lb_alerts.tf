data "azurerm_monitor_action_group" "dev" {
  resource_group_name = "vh-infra-core-${env}"
  name                = "Vh-Action-Group-dev-${var.env}"
}

data "azurerm_monitor_action_group" "dev" {
  resource_group_name = "vh-infra-core-${env}"
  name                = "Vh-Action-Group-devops-${var.env}"
}

locals {
  wowzaLoadBalancers = {
    private = {
      scope = [azurerm_lb.wowza.id]
      name  = "vh-wowza-lb-private-alert-"
    }
    public = {
      scope = [azurerm_lb.wowza-public.id]
      name  = "vh-wowza-lb-public-alert-"
    }
  }
}

resource "azurerm_monitor_metric_alert" "wowza_lb_alert" {
  for_each = var.env == "prod" ? local.wowzaLoadBalancers : {}

  name                = "${each.value.name}${var.env}"
  resource_group_name = var.resource_group_name
  scopes              = each.value.scope
  description         = "Wowza Load Balancer Health is Below 95%, Please Investigate ASAP as this may impact the service."

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
    action_group_id = azurerm_monitor_action_group.dev.id
  }

  action {
    action_group_id = azurerm_monitor_action_group.devops.id
  }
}