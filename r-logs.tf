resource "azurerm_monitor_diagnostic_setting" "frontdoor_log_storage" {
  count = var.enable_logging ? 1 : 0

  name               = local.diag_settings_name
  target_resource_id = azurerm_frontdoor.frontdoor.id

  storage_account_id         = var.logs_storage_account_id
  log_analytics_workspace_id = var.logs_log_analytics_workspace_id

  log {
    category = "FrontdoorWebApplicationFirewallLog"

    retention_policy {
      enabled = true
      days    = var.logs_storage_retention
    }
  }

  log {
    category = "FrontdoorAccessLog"

    retention_policy {
      enabled = true
      days    = var.logs_storage_retention
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = var.logs_enable_metrics

    retention_policy {
      enabled = true
      days    = var.logs_storage_retention
    }
  }
}
