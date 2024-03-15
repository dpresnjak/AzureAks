## Various resources that don't have enough to warrant a separate module
# DNS Zone
# Service Bus queues
# Function triggers

#######################
###### DNS Zone #######
#######################

resource "azurerm_private_dns_zone" "pvt_dns_zone" {
  name                = "${var.prefix}.postgres.database.azure.com"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "psql_link" {
  name                  = "${var.prefix}-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.pvt_dns_zone.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.rg_name
}

#######################
#### Service Buses ####
#######################
# Two different namespaces and queues
# AKS -> doc-processor-queue -> doc-processor-app -> doc-extractor-queue -> doc-extractor-app

# Doc Processor
resource "azurerm_servicebus_namespace" "sbus_processor_namespace" {
  name                = "${var.prefix}sbusprocnamesp"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.sbus_namespace_sku
}

resource "azurerm_servicebus_queue" "sbus_processor_queue" {
  name                = "${var.prefix}sbusprocqueue"
  namespace_id        = azurerm_servicebus_namespace.sbus_processor_namespace.id
  enable_partitioning = true
  lock_duration       = "PT1M"
}

resource "azurerm_servicebus_namespace_authorization_rule" "sbus_processor_rule" {
  name         = "${var.prefix}procfunctionrule"
  namespace_id = azurerm_servicebus_namespace.sbus_processor_namespace.id
  listen       = true
  send         = true
  manage       = true
}

## Doc Extractor
resource "azurerm_servicebus_namespace" "sub_extractor_namespace" {
  name                = "${var.prefix}sbusextrnamesp"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.sbus_namespace_sku
}

resource "azurerm_servicebus_queue" "sbus_extractor_queue" {
  name                = "${var.prefix}sbusextrqueue"
  namespace_id        = azurerm_servicebus_namespace.sub_extractor_namespace.id
  enable_partitioning = true
  lock_duration       = "PT1M"
}

resource "azurerm_servicebus_namespace_authorization_rule" "sbus_extractor_rule" {
  name         = "${var.prefix}extrfunctionrule"
  namespace_id = azurerm_servicebus_namespace.sub_extractor_namespace.id
  listen       = true
  send         = true
  manage       = true
}

#######################
##### Permissions #####
#######################

# resource "azurerm_role_assignment" "function_role_proc" {
#   scope                = azurerm_servicebus_queue.sbus_processor_queue.id
#   role_definition_name = "Azure Service Bus Data Owner"
#   principal_id         = var.doc_proc_principal_id
#   #skip_service_principal_aad_check = true
#   #principal_type = "User"
# }

# resource "azurerm_role_assignment" "function_role_extr" {
#   scope                = azurerm_servicebus_queue.sbus_extractor_queue.id
#   role_definition_name = "Azure Service Bus Data Owner"
#   principal_id         = var.doc_ext_principal_id
#   #skip_service_principal_aad_check = true
#   #principal_type = "User"
# }