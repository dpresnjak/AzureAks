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
variable "virtual_network_id" {
  type = string
}
variable "doc_ext_principal_id" {
  type    = string
  default = null
}
variable "doc_proc_principal_id" {
  type    = string
  default = null
}
variable "sbus_namespace_sku" {
  type = string
}