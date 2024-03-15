output "func_app_insights_conn_string" {
  value = azurerm_application_insights.func_app_insights.connection_string
}
output "func_app_insights_key" {
  value = azurerm_application_insights.func_app_insights.instrumentation_key
}
# output "psql_app_insights_conn_string" {
#   value = azurerm_application_insights.psql_app_insights.connection_string
# }
# output "psql_app_insights_key" {
#   value = azurerm_application_insights.psql_app_insights.instrumentation_key
# }