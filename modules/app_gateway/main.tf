# Routing rules
# Backend pool
# Since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.vnet_name}-beap"
  frontend_port_name             = "${var.vnet_name}-feport"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name              = "${var.vnet_name}-be-htst"
  listener_name                  = "${var.vnet_name}-httplstn"
  request_routing_rule_name      = "${var.vnet_name}-rqrt"
  redirect_configuration_name    = "${var.vnet_name}-rdrcfg"
  probe_name                     = "nginx-hc"
}


resource "azurerm_application_gateway" "app_gateway" {
  name                = "${var.prefix}${var.appgw_name}"
  resource_group_name = var.rg_name
  location            = var.location
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.public_sub_id # Public Subnet ID
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  frontend_port {
    name = "httpsPort"
    port = 443
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.app_gateway_public_ip_id
  }
  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = ["${var.ingress_ip}"] # nginx-ingress LoadBalancer ExternalIP
  }
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    probe_name            = local.probe_name
  }
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }
  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.appgw_capacity
  }
  probe {
    host                = var.appgw_probe_host
    interval            = 30
    name                = local.probe_name
    path                = "/nginx-health"
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 3
  }
}
