#######################
###### Functions ######
#######################

resource "azurerm_log_analytics_workspace" "log_workspace_functions" {
  name                = "dpres-functions-workspace"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_application_insights" "func_app_insights" {
  depends_on          = [azurerm_log_analytics_workspace.log_workspace_functions]
  name                = "dpres-function-insights"
  resource_group_name = var.rg_name
  location            = var.location
  application_type    = "other"
  retention_in_days   = 30
  workspace_id        = azurerm_log_analytics_workspace.log_workspace_functions.id
}

# resource "azurerm_monitor_diagnostic_setting" "proc_func_setting" {
#   name = "dpres-proc-func-setting"
#   target_resource_id = var.doc_proc_app_id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace_functions.id
#   metric {
#     category = "AllMetrics"
#     enabled = true
#   }
# }
# resource "azurerm_monitor_diagnostic_setting" "extr_func_setting" {
#   name = "dpres-extr-func-setting"
#   target_resource_id = var.doc_extr_app_id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace_functions.id
#   metric {
#     category = "AllMetrics"
#     enabled = true
#   }
# }

# resource "azurerm_monitor_diagnostic_setting" "proc_func_setting_func" {
#   name = "dpres-proc-func-setting"
#   target_resource_id = var.doc_proc_id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace_functions.id
#   metric {
#     category = "AllMetrics"
#     enabled = true
#   }
# }
# resource "azurerm_monitor_diagnostic_setting" "extr_func_setting_func" {
#   name = "dpres-extr-func-setting"
#   target_resource_id = var.doc_extr_id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace_functions.id
#   metric {
#     category = "AllMetrics"
#     enabled = true
#   }
# }
#######################
#### PSQL Server/DB ###
#######################
## None of this is supported as of February 2024.
## Options are either PSQL built-in logs or pgaudit
# resource "azurerm_log_analytics_workspace" "log_workspace_psql" {
#   name                = "dpres-psql-workspace"
#   resource_group_name = var.rg_name
#   location            = var.location
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   identity {
#     type = "SystemAssigned"
#   }
# }
# resource "azurerm_application_insights" "psql_app_insights" {
#   depends_on = [ azurerm_log_analytics_workspace.log_workspace_psql ]
#   name                = "dpres-psql-insights"
#   resource_group_name = var.rg_name
#   location            = var.location
#   application_type    = "other"
#   retention_in_days   = 30
#   workspace_id = azurerm_log_analytics_workspace.log_workspace_psql.id
# }
# resource "azurerm_monitor_diagnostic_setting" "psql_general_setting" {
#   name = "dpres-psql-general-setting"
#   target_resource_id = var.psql_server_id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace_psql.id
#   enabled_log {
#     category = "generalLogs"
#   }
# }
# resource "azurerm_monitor_diagnostic_setting" "psql_slowquery_setting" {
#   name = "dpres-psql-general-setting"
#   target_resource_id = var.psql_server_id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace_psql.id
#   enabled_log {
#     category = "slow_query_logs"
#   }
# }