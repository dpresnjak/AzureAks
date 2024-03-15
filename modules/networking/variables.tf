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
variable "virtual_network_address_prefix" {
  type = string
}
variable "public_subnet_prefix" {
  type = string
}
variable "private_subnet_prefix" {
  type = string
}
variable "psql_private_subnet_prefix" {
  type = string
}