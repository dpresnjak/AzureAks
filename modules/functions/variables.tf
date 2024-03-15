## Global configuration
variable "prefix" {
  type = string
}
variable "location" {
  type        = string
  description = "Resource Group location."
}
variable "rg_name" {
  type        = string
  description = "Resource Group name."
}
variable "acr_username" {
  type = string
}
variable "acr_password" {
  type = string
}
## Storage
variable "acr_url" {
  type    = any
  default = []
}
variable "acr_client_id" {
  type    = any
  default = []
}
variable "storage_account_name" {
  type    = any
  default = []
}
variable "storage_access_key" {
  type    = any
  default = []
}
variable "storage_container_name" {
  type    = any
  default = []
}
variable "identity_client_id" {
  type = string
}
## Networking
variable "private_sub_id" {
  type = string
}

## Service Bus
variable "sbus_proc_queue_name" {
  type = string
}
variable "sbus_proc_namespace_id" {
  type = string
}
variable "sbus_proc_namespace_name" {
  type = string
}
variable "sbus_proc_namespace_connection" {
  type = string
}
variable "sbus_extr_queue_name" {
  type = string
}
variable "sbus_extr_namespace_id" {
  type = string
}
variable "sbus_extr_namespace_name" {
  type = string
}
variable "sbus_extr_namespace_connection" {
  type = string
}

## Monitoring, logging
variable "func_app_insights_conn_string" {
  type    = string
  default = null
}
variable "func_app_insights_key" {
  type    = string
  default = null
}
variable "psql_app_insights_conn_string" {
  type    = string
  default = null
}
variable "psql_app_insights_key" {
  type    = string
  default = null
}