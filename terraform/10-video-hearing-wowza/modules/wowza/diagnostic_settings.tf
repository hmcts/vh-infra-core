resource "azurerm_monitor_diagnostic_setting" "storage_account" {
  name                       = "vh-sa-${var.environment}-diag-set"
  target_resource_id         = module.wowza_recordings.storageaccount_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  metric {
    category = "Capacity"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  metric {

    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  name                       = "vh-nsg-${var.environment}-diag-set"
  target_resource_id         = azurerm_network_security_group.wowza.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nics" {
  count = var.wowza_instance_count

  name                       = "vh-nic${count.index + 1}-${var.environment}-diag-set"
  target_resource_id         = azurerm_network_interface.wowza[count.index].id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}


resource "azurerm_monitor_diagnostic_setting" "load_balancer" {
  name                       = "vh-lb-${var.environment}-diag-set"
  target_resource_id         = azurerm_lb.wowza.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  log {
    category = "LoadBalancerAlertEvent"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "LoadBalancerProbeHealthStatus"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "load_balancer_public" {
  name                       = "vh-lb-public-${var.environment}-diag-set"
  target_resource_id         = azurerm_lb.wowza-public.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id

  log {
    category = "LoadBalancerAlertEvent"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "LoadBalancerProbeHealthStatus"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}