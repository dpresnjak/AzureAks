variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "doc_proc_id" {
  type    = string
  default = null
}
variable "doc_extr_id" {
  type    = string
  default = null
}
variable "doc_proc_app_id" {
  type    = string
  default = null
}
variable "doc_extr_app_id" {
  type    = string
  default = null
}
variable "psql_server_id" {
  type = string
}
variable "psql_db_id" {
  type = string
}