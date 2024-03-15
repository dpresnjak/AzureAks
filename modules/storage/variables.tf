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

## Storage
variable "acr_url" {
  type    = any
  default = []
}
variable "acr_client_id" {
  type    = any
  default = []
}
variable "storage_access_key" {
  type    = any
  default = []
}
variable "storage_account_name" {
  type = string
}
variable "storage_account_tier" {
  type = string
}
variable "account_replication_type" {
  type = string
}
variable "storage_container_name" {
  type = string
}
variable "container_access_type" {
  type = string
}
variable "storage_blob_name" {
  type = string
}
variable "storage_blob_type" {
  type = string
}
variable "acr_name" {
  type = string
}
variable "acr_sku" {
  type = string
}
variable "acr_scope_map_name" {
  type = string
}
variable "acr_token_name" {
  type = string
}
variable "key_vault_name" {
  type = string
}
variable "key_vault_sku" {
  type = string
}
variable "key_vault_key_name" {
  type = string
}
variable "psql_server_name" {
  type = string
}
variable "psql_sku_name" {
  type = string
}
variable "psql_storage_size" {
  type = number
}
variable "psql_db_name" {
  type = string
}

## Networking
variable "private_sub_id" {
  description = "Private subnet ID."
}
variable "public_sub_id" {
  description = "Public subnet ID."
}
variable "private_sub_id_psql" {
}
variable "private_cidr_psql" {
}
variable "pvt_dns_zone_id" {
}