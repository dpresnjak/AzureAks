variable "location" {
  type        = string
  description = "Resource Group location."
}
variable "rg_name" {
  type        = string
  description = "Resource Group name."
}
variable "sbus_proc_queue_id" {
  type = string
}
variable "sbus_extr_queue_id" {
  type = string
}
variable "prefix" {}
variable "aks_agent_vm_size" {}
variable "aks_cluster_name" {}
variable "aks_service_cidr" {}
variable "aks_dns_service_ip" {}

## Kubernetes
variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
}
variable "admin_username" {
  type        = string
  description = "The admin username for the new cluster."
}
variable "client_certificate" {
  type    = string
  default = null
}
variable "client_key" {
  type    = string
  default = null
}
variable "cluster_ca_certificate" {
  type    = string
  default = null
}
variable "cluster_password" {
  type      = string
  sensitive = true
  default   = null
}
variable "cluster_username" {
  type    = string
  default = null
}
variable "host" {
  type    = string
  default = null
}
variable "kube_config" {
  type    = string
  default = null
}
variable "k8s_fqdn" {
  type    = string
  default = null
}
variable "private_fqdn" {
  type    = string
  default = null
}
variable "k8s_principal_id" {
  type        = string
  description = "Kubernetes cluster principal identity ID."
  default     = null
}
variable "helm_dependency" {
  type    = string
  default = null
}

## Networking
variable "public_sub_id" {
  type    = string
  default = null
}
variable "private_sub_id" {
  type    = string
  default = null
}
variable "app_gateway_id" {
  type = string
}
variable "private_cidr" {
  type = string
}
variable "public_cidr" {
  type = string
}
variable "app_gateway_public_ip" {
  type = string
}
variable "app_gateway_public_ip_id" {
  type = string
}
variable "vnet_name" {
  type = string
}

## Storage
variable "acr_url" {
  type    = string
  default = null
}
variable "acr_username" {
  type    = string
  default = null
}
variable "acr_client_id" {
  type    = string
  default = null
}
variable "storage_account_name" {
  type    = string
  default = null
}
variable "storage_container_name" {
  type    = string
  default = null
}
variable "storage_access_key" {
  type    = string
  default = null
}
variable "key_vault_id" {
  type    = string
  default = null
}
variable "key_vault_key_id" {
  type    = string
  default = null
}
variable "acr_id" {
  type    = string
  default = null
}