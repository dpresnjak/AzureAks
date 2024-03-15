variable "prefix" {
  type    = string
  default = "dpres"
}
variable "location" {
  type        = string
  description = "Resource Group location."
}
variable "rg_name" {
  type        = string
  description = "Resource Group name."
}
variable "vnet_name" {
  type        = string
  description = "Virtual Network name."
}
variable "app_gateway_public_ip" {
  type        = string
  description = "Application gateway public IP."
}
variable "app_gateway_public_ip_id" {
  type        = string
  description = "Application gateway public IP - ID."
}
variable "ingress_ip" {
  type        = string
  description = "Nginx Ingress ExternalIP"
}
variable "private_sub_id" {
  description = "Private subnet ID."
}
variable "public_sub_id" {
  description = "Public subnet ID."
}
variable "private_fqdn" {
  description = "Kubernetes cluster FQDN"
}
variable "k8s_fqdn" {
  description = "Kubernetes cluster FQDN"
}
## App Gateway
variable "appgw_name" {
  type = string
}
variable "appgw_probe_host" {
  type = string
}
variable "appgw_sku_name" {
  type = string
}
variable "appgw_sku_tier" {
  type = string
}
variable "appgw_capacity" {
  type = number
}