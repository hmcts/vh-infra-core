data "azurerm_log_analytics_workspace" "core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = "vh-infra-core-${var.environment}"
}

data "azurerm_network_watcher" "this" {
  name                = "NetworkWatcher_${azurerm_resource_group.wowza.location}"
  resource_group_name = "NetworkWatcherRG"
}

resource "azurerm_network_watcher_flow_log" "nsg" {
  network_watcher_name = azurerm_network_watcher.wowza.name
  resource_group_name  = azurerm_resource_group.wowza.name
  name                 = "${var.service_name}-flow-logs"

  network_security_group_id = azurerm_network_security_group.wowza.id
  storage_account_id        = azurerm_storage_account.wowza_recordings.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.core.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.core.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.core.id
    interval_in_minutes   = 10
  }

  tags = var.tags
}