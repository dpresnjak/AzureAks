resource "azurerm_service_plan" "service_plan" {
  name                = "${var.prefix}ServicePlan"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

#######################
##### Connections #####
#######################
## These connections only create a link between the services, they are not called anywhere
# Service Bus trigger
#https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-service-bus-output?tabs=python-v2%2Cisolated-process%2Cnodejs-v4%2Cextensionv5&pivots=programming-language-python
# Service Bus output
#https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-service-bus-trigger?tabs=python-v2%2Cisolated-process%2Cnodejs-v4%2Cextensionv5&pivots=programming-language-python

## Doc Processor queue -> Doc Processor function
resource "azurerm_function_app_connection" "sbus_proc_connection" {
  depends_on         = [azurerm_linux_function_app.doc_processor_app, azurerm_linux_function_app.doc_text_extractor_app]
  name               = "dpres_sbus_proc_connector"
  function_app_id    = azurerm_linux_function_app.doc_processor_app.id
  target_resource_id = var.sbus_proc_namespace_id
  authentication {
    type = "systemAssignedIdentity"
  }
}

## Doc Processor function -> Doc Extractor queue
resource "azurerm_function_app_connection" "sbus_proc_to_extr_connection" {
  depends_on         = [azurerm_linux_function_app.doc_processor_app, azurerm_linux_function_app.doc_text_extractor_app]
  name               = "dpres_sbus_proc_extr_connector"
  function_app_id    = azurerm_linux_function_app.doc_processor_app.id
  target_resource_id = var.sbus_extr_namespace_id
  authentication {
    type = "systemAssignedIdentity"
  }
}

## Doc Extractor queue -> Doc Extractor function
resource "azurerm_function_app_connection" "sbus_extr_connection" {
  depends_on         = [azurerm_linux_function_app.doc_processor_app, azurerm_linux_function_app.doc_text_extractor_app]
  name               = "dpres_sbus_extr_connector"
  function_app_id    = azurerm_linux_function_app.doc_text_extractor_app.id
  target_resource_id = var.sbus_extr_namespace_id
  authentication {
    type = "systemAssignedIdentity"
  }
}

#######################
###### Functions ######
#######################

## Document processor Function
resource "azurerm_linux_function_app" "doc_processor_app" {
  depends_on                    = [var.acr_url]
  name                          = "${var.prefix}ProcApp"
  resource_group_name           = var.rg_name
  location                      = var.location
  storage_account_name          = "${var.prefix}portalaccount2202"
  storage_account_access_key    = var.storage_access_key
  service_plan_id               = azurerm_service_plan.service_plan.id
  public_network_access_enabled = true
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    #"WEBSITE_RUN_FROM_PACKAGE" = 0
    "AzureWebJobsDisableHomepage"                                             = "false"
    "FUNCTION_APP_EDIT_MODE"                                                  = "readwrite"
    "${var.sbus_proc_namespace_name}_ConnectionString"                        = "${var.sbus_proc_namespace_connection}"
    "${var.sbus_extr_namespace_name}_ConnectionString"                        = "${var.sbus_extr_namespace_connection}"
    "AZURE_SERVICEBUS_DPRES_SBUS_PROC_CONNECTOR_FULLYQUALIFIEDNAMESPACE"      = "${var.sbus_proc_namespace_name}.servicebus.windows.net"
    "AZURE_SERVICEBUS_DPRES_SBUS_PROC_EXTR_CONNECTOR_FULLYQUALIFIEDNAMESPACE" = "${var.sbus_extr_namespace_name}.servicebus.windows.net"
    "APPINSIGHTS_INSTRUMENTATIONKEY"                                          = "${var.func_app_insights_key}"
  }
  sticky_settings {
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "${var.sbus_proc_namespace_name}_ConnectionString",
      "${var.sbus_extr_namespace_name}_ConnectionString",
      "AZURE_SERVICEBUS_DPRES_SBUS_PROC_CONNECTOR_FULLYQUALIFIEDNAMESPACE"
    ]
  }
  identity {
    type = "SystemAssigned"
  }
  storage_account {
    account_name = var.storage_account_name
    access_key   = var.storage_access_key
    name         = "${var.prefix}-storage"
    share_name   = var.storage_container_name
    type         = "AzureBlob"
  }
  #storage_uses_managed_identity = true
  site_config {
    #websockets_enabled = true
    application_stack {
      python_version = 3.11
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
    container_registry_managed_identity_client_id = var.identity_client_id
    # container_registry_use_managed_identity = true
    # ip_restriction {
    #   virtual_network_subnet_id = var.private_sub_id
    #   action = "Allow"
    #   name = "allow_from_private"
    # }
    always_on = false
  }
}



resource "azurerm_function_app_function" "doc_processor_func" {
  name            = "ProcFunction"
  function_app_id = azurerm_linux_function_app.doc_processor_app.id
  language        = "Python"
  file {
    name    = "doc_proc_func.py"
    content = file("./modules/functions/doc_proc_func.py")
  }
  config_json = jsonencode({
    "scriptFile" : "doc_proc_func.py"
    "bindings" = [
      {
        "authLevel" : "anonymous"
        "name" : "msgIn",
        "type" : "serviceBusTrigger",
        "direction" : "in",
        "queueName" : "${var.sbus_proc_queue_name}",
        "connection" : "${var.sbus_proc_namespace_name}_ConnectionString",
      },
      {
        "name" : "msgOut",
        "type" : "serviceBus",
        "direction" : "out",
        "queueName" : "${var.sbus_extr_queue_name}",
        "connection" : "${var.sbus_extr_namespace_name}_ConnectionString",
      }
    ]
    }
  )
}

###################################
###################################

## Document text extractor Function
resource "azurerm_linux_function_app" "doc_text_extractor_app" {
  depends_on                    = [var.acr_url]
  name                          = "${var.prefix}ExtrApp"
  resource_group_name           = var.rg_name
  location                      = var.location
  storage_account_name          = "${var.prefix}portalaccount2202"
  storage_account_access_key    = var.storage_access_key
  service_plan_id               = azurerm_service_plan.service_plan.id
  public_network_access_enabled = true
  #virtual_network_subnet_id = var.private_sub_id
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    #"WEBSITE_RUN_FROM_PACKAGE" = 0
    "AzureWebJobsDisableHomepage"                                        = "false"
    "FUNCTION_APP_EDIT_MODE"                                             = "readwrite"
    "${var.sbus_extr_namespace_name}_ConnectionString"                   = "${var.sbus_extr_namespace_connection}"
    "APPINSIGHTS_INSTRUMENTATIONKEY"                                     = "${var.func_app_insights_key}"
    "AZURE_SERVICEBUS_DPRES_SBUS_EXTR_CONNECTOR_FULLYQUALIFIEDNAMESPACE" = "${var.sbus_extr_namespace_name}.servicebus.windows.net"
  }
  identity {
    type = "SystemAssigned"
  }
  storage_account {
    account_name = var.storage_account_name
    access_key   = var.storage_access_key
    name         = "${var.prefix}-storage"
    share_name   = var.storage_container_name
    type         = "AzureBlob"
  }
  #storage_uses_managed_identity = true
  site_config {
    #websockets_enabled = true
    application_stack {
      python_version = 3.11
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
    container_registry_managed_identity_client_id = var.identity_client_id
    always_on                                     = false
  }
}

resource "azurerm_function_app_function" "doc_text_extractor_func" {
  name            = "ExtrFunction"
  function_app_id = azurerm_linux_function_app.doc_text_extractor_app.id
  language        = "Python"
  file {
    name    = "doc_extr_func.py"
    content = file("./modules/functions/doc_extr_func.py")
  }
  config_json = jsonencode({
    "scriptFile" : "doc_extr_func.py",
    "bindings" = [
      {
        "name" : "msgIn",
        "type" : "serviceBusTrigger",
        "direction" : "in",
        "queueName" : "${var.sbus_extr_queue_name}",
        "connection" : "${var.sbus_extr_namespace_name}_ConnectionString",
      }
    ]
    }
  )
}
