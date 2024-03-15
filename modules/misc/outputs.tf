## Doc processor namespace, queue
output "sbus_proc_queue_name" {
  value = azurerm_servicebus_queue.sbus_processor_queue.name
}
output "sbus_proc_namespace_connection" {
  value = azurerm_servicebus_namespace.sbus_processor_namespace.default_primary_connection_string
}
output "sbus_proc_namespace_id" {
  value = azurerm_servicebus_namespace.sbus_processor_namespace.id
}
output "sbus_proc_namespace_name" {
  value = azurerm_servicebus_namespace.sbus_processor_namespace.name
}
output "sbus_proc_queue_id" {
  value = azurerm_servicebus_queue.sbus_processor_queue.id
}

## Doc extractor namespace, queue
output "sbus_extr_queue_name" {
  value = azurerm_servicebus_queue.sbus_extractor_queue.name
}
output "sbus_extr_namespace_connection" {
  value = azurerm_servicebus_namespace.sub_extractor_namespace.default_primary_connection_string
}
output "sbus_extr_namespace_id" {
  value = azurerm_servicebus_namespace.sub_extractor_namespace.id
}
output "sbus_extr_namespace_name" {
  value = azurerm_servicebus_namespace.sub_extractor_namespace.name
}
output "sbus_extr_queue_id" {
  value = azurerm_servicebus_queue.sbus_extractor_queue.id
}

## DNS zone
output "pvt_dns_zone_id" {
  value = azurerm_private_dns_zone.pvt_dns_zone.id
}