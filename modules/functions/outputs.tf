output "doc_proc_invoke_url" {
  value = azurerm_function_app_function.doc_processor_func.invocation_url
}
output "doc_proc_id" {
  value = azurerm_function_app_function.doc_processor_func.id
}
output "doc_extractor_invoke_url" {
  value = azurerm_function_app_function.doc_text_extractor_func.invocation_url
}
output "doc_extractor_id" {
  value = azurerm_function_app_function.doc_text_extractor_func.id
}
output "doc_proc_principal_id" {
  value = azurerm_linux_function_app.doc_processor_app.identity.0.principal_id
}
output "doc_ext_principal_id" {
  value = azurerm_linux_function_app.doc_text_extractor_app.identity.0.principal_id
}
output "doc_proc_app_id" {
  value = azurerm_linux_function_app.doc_processor_app.id
}
output "doc_extr_app_id" {
  value = azurerm_linux_function_app.doc_text_extractor_app.id
}