###################
##### Global ######
###################

variable "prefix" {
  type        = string
  description = "Prefix for most resource names that will be created."
}
variable "location" {
  type        = string
  description = "Resource Group location."
}
variable "rg_name" {
  type        = string
  description = "Resource Group name."
}

#######################
##### Kubernetes ######
#######################

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
}
variable "admin_username" {
  type        = string
  description = "The admin username for the new cluster."
}
variable "aks_agent_vm_size" {
  type        = string
  description = "Size of AKS nodes for the node pool. Ex. Standard_D2_v2"
}
variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster."
}
variable "aks_service_cidr" {
  type        = string
  description = "Network range used by the Kubernetes service."
}
variable "aks_dns_service_ip" {
  type        = string
  description = "IP address that will be used by cluster service discovery (kube-dns)."
}
variable "client_certificate" {
  type        = string
  default     = null
  description = "Kubernetes client certificate used for authentication during deployment."
}
variable "client_key" {
  type        = string
  default     = null
  description = "Kubernetes client key used for authentication during deployment."
}
variable "cluster_ca_certificate" {
  type        = string
  default     = null
  description = "Kubernetes cluster certificate used for authentication during deployment."
}
variable "cluster_password" {
  type        = string
  sensitive   = true
  default     = null
  description = "Kubernetes cluster password."
}
variable "cluster_username" {
  type        = string
  default     = null
  description = "Kubernetes cluster username."
}
variable "host" {
  type        = string
  default     = null
  description = "Kubernetes cluster server host."
}
variable "kube_config" {
  type        = string
  default     = null
  description = "Kubernetes config used for getting authentication information."
}
variable "k8s_fqdn" {
  type        = string
  default     = null
  description = "FQDN of the Azure Kubernetes cluster."
}
variable "private_fqdn" {
  type        = string
  default     = null
  description = "The FQDN for the Azure Portal resources when private link has been enabled." #Unused atm
}
variable "k8s_principal_id" {
  type        = string
  description = "Kubernetes cluster principal identity ID."
  default     = null
}

#######################
##### App Gateway #####
#######################
variable "appgw_name" {
  type        = string
  description = "Application gateway name."
}
variable "appgw_probe_host" {
  type        = string
  description = "Application gateway FQDN; used for nginx-ingress healthcheck."
}
variable "appgw_sku_name" {
  type        = string
  description = "Application gateway SKU name. Ex. Standard_v2"
}
variable "appgw_sku_tier" {
  type        = string
  description = "Application gateway SKU name. Ex. Standard_v2"
}
variable "appgw_capacity" {
  type        = number
  description = "Number of instances for the Application gateway."
}

#######################
##### Networking ######
#######################

variable "public_sub_id" {
  type        = string
  default     = null
  description = "ID of the public subnet in the virtual network."
}
variable "private_sub_id" {
  type        = string
  default     = null
  description = "ID of the private subnet in the virtual network."
}
variable "private_sub_id_psql" {
  type        = string
  default     = null
  description = "ID of the public subnet for PSQL flexible server in the virtual network."
}
variable "private_cidr_psql" {
  type        = string
  default     = null
  description = "Cidr of the public subnet for PSQL flexible server in the virtual network."
}
variable "vnet_id" {
  type        = string
  default     = null
  description = "Virtual network ID."
}
variable "pvt_dns_zone_id" {
  type        = string
  default     = null
  description = "Private DNS zone ID."
}
variable "virtual_network_address_prefix" {
  type        = string
  description = "Virtual network address prefix."
}
variable "public_subnet_prefix" {
  type        = string
  description = "Public subnet address prefix."
}
variable "private_subnet_prefix" {
  type        = string
  description = "Private subnet address prefix."
}
variable "psql_private_subnet_prefix" {
  type        = string
  default     = null
  description = "Private subnet address prefix for the PSQL flexible server."
}

####################
##### Storage ######
####################

variable "acr_name" {
  type        = string
  description = "Azure Container Repository name."
}
variable "acr_sku" {
  type        = string
  description = "Azure Container Repository SKU. Ex. Standard, Premium."
}
variable "acr_scope_map_name" {
  type        = string
  description = "Azure Container Repository scope map name."
}
variable "acr_token_name" {
  type        = string
  description = "Azure Container Repository token name."
}
variable "acr_url" {
  type        = string
  default     = null
  description = "Azure Container Repository URL."
}
variable "acr_username" {
  type        = string
  default     = null
  description = "Azure Container Repository username."
}
variable "acr_client_id" {
  type        = string
  default     = null
  description = "Azure Container Repository client ID."
}
variable "acr_password" {
  type        = string
  default     = null
  description = "Azure Container Repository password."
}
variable "acr_id" {
  type        = string
  default     = null
  description = "Azure Container Repository ID."
}
variable "storage_access_key" {
  type        = string
  default     = null
  description = "Storage account access key."
}
variable "identity_client_id" {
  type    = string
  default = null
}
variable "storage_account_name" {
  type        = string
  description = "Storage account name."
}
variable "storage_account_tier" {
  type        = string
  description = "Storage account tier. Ex. Standard."
}
variable "account_replication_type" {
  type        = string
  description = "Storage account replication type. Ex. LRS, GRS"
}
variable "storage_container_name" {
  type        = string
  description = "Storage container name."
}
variable "container_access_type" {
  type        = string
  description = "Storage container access type. Ex. private, public"
}
variable "storage_blob_name" {
  type        = string
  description = "Storage blob name."
}
variable "storage_blob_type" {
  type        = string
  description = "Storage blob type. Ex. Block"
}
variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault."
}
variable "key_vault_sku" {
  type        = string
  description = "Azure Key Vault SKU. Ex. Standard, Premium."
}
variable "key_vault_key_name" {
  type        = string
  description = "Azure Key Vault access key name."
}
variable "psql_server_name" {
  type        = string
  description = "Flexible PSQL server name."
}
variable "psql_sku_name" {
  type        = string
  description = "Flexible PSQL server SKU. Ex. B_Standard_B1ms"
}
variable "psql_storage_size" {
  type        = number
  description = "Flexible PSQL server storage size in MB."
}
variable "psql_db_name" {
  type        = string
  description = "Flexible PSQL server database name."
}

#######################
##### Service Bus #####
#######################

variable "doc_ext_principal_id" {
  type    = string
  default = null
}
variable "sbus_namespace_sku" {
  type = string
}

#######################
##### Monitoring ######
#######################

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