# ---------------------------------------------------------------------------
# Log Analytics - for storing the applications logs
# ---------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "arena" {
  name                = "${var.prefix}-logs"
  resource_group_name = azurerm_resource_group.arena.name
  location            = azurerm_resource_group.arena.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# ---------------------------------------------------------------------------
# Diagnostic settings - ship the Console Logs into the Log Analytics Workspace
# so they are KQL-queryable in the Monitoring -> Telemetry UI
#
# Within the Locally Dashboard these can be queried using:
#   AppServiceConsoleLogs | order by TimeGenerated desc
# ---------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "arena" {
  name                       = "console-logs"
  target_resource_id         = azurerm_linux_web_app.arena.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.arena.id

  enabled_log {
    category = "AppServiceConsoleLogs"
  }
}
