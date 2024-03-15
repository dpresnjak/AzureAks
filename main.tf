data "azurerm_subscription" "current" {
}

#######################
####### Network #######
#######################

module "networking" {
  source                         = "./modules/networking"
  rg_name                        = var.rg_name
  location                       = var.location
  prefix                         = var.prefix
  virtual_network_address_prefix = var.virtual_network_address_prefix
  public_subnet_prefix           = var.public_subnet_prefix
  private_subnet_prefix          = var.private_subnet_prefix
  psql_private_subnet_prefix     = var.psql_private_subnet_prefix
}

#######################
# Application Gateway #
#######################

module "application_gateway" {
  source                   = "./modules/app_gateway"
  rg_name                  = var.rg_name
  location                 = var.location
  app_gateway_public_ip_id = module.networking.app_gateway_public_ip_id
  app_gateway_public_ip    = module.networking.app_gateway_public_ip
  appgw_capacity           = var.appgw_capacity
  appgw_name               = var.appgw_name
  appgw_probe_host         = var.appgw_probe_host
  appgw_sku_name           = var.appgw_sku_name
  appgw_sku_tier           = var.appgw_sku_tier
  ingress_ip               = module.kubernetes.ingress_ip
  k8s_fqdn                 = module.kubernetes.k8s_fqdn
  private_fqdn             = module.kubernetes.private_fqdn
  private_sub_id           = module.networking.private_sub_id
  public_sub_id            = module.networking.public_sub_id
  vnet_name                = module.networking.vnet_name
}

#######################
##### Kubernetes ######
#######################
# https://github.com/Azure/terraform-azurerm-aks/blob/main/README.md

module "kubernetes" {
  source                   = "./modules/kubernetes"
  rg_name                  = var.rg_name
  location                 = var.location
  acr_id                   = module.storage.acr_id
  admin_username           = var.admin_username
  aks_agent_vm_size        = var.aks_agent_vm_size
  aks_cluster_name         = var.aks_cluster_name
  aks_dns_service_ip       = var.aks_dns_service_ip
  aks_service_cidr         = var.aks_service_cidr
  app_gateway_id           = module.application_gateway.app_gateway_id
  app_gateway_public_ip_id = module.networking.app_gateway_public_ip_id
  app_gateway_public_ip    = module.networking.app_gateway_public_ip
  helm_dependency          = module.helm_charts.helm_dependency
  key_vault_id             = module.storage.key_vault_id
  key_vault_key_id         = module.storage.key_vault_key_id
  node_count               = var.node_count
  prefix                   = var.prefix
  private_cidr             = module.networking.private_cidr
  private_sub_id           = module.networking.private_sub_id
  public_cidr              = module.networking.public_cidr
  public_sub_id            = module.networking.public_sub_id
  sbus_extr_queue_id       = module.misc.sbus_extr_queue_id
  sbus_proc_queue_id       = module.misc.sbus_proc_queue_id
  vnet_name                = module.networking.vnet_name
}

#######################
##### Helm charts #####
#######################

module "helm_charts" {
  source                 = "./modules/helm_charts"
  host                   = module.kubernetes.host
  username               = module.kubernetes.cluster_username
  password               = module.kubernetes.cluster_password
  client_certificate     = base64decode(module.kubernetes.client_certificate)
  client_key             = base64decode(module.kubernetes.client_key)
  cluster_ca_certificate = base64decode(module.kubernetes.cluster_ca_certificate)
}

#######################
###### Functions ######
#######################

module "functions" {
  source                    = "./modules/functions"
  rg_name                   = var.rg_name
  location                  = var.location
  prefix                    = var.prefix
  acr_client_id             = module.storage.acr_client_id
  acr_url                   = module.storage.acr_url
  acr_username              = module.storage.acr_username
  acr_password              = module.storage.acr_password
  storage_account_name      = module.storage.storage_account_name
  private_sub_id            = module.networking.private_sub_id
  storage_access_key        = module.storage.storage_access_key
  storage_container_name    = module.storage.storage_container_name
  identity_client_id        = var.identity_client_id
  sbus_proc_queue_name           = module.misc.sbus_proc_queue_name
  sbus_proc_namespace_id         = module.misc.sbus_proc_namespace_id
  sbus_proc_namespace_name       = module.misc.sbus_proc_namespace_name
  sbus_proc_namespace_connection = module.misc.sbus_proc_namespace_connection
  sbus_extr_queue_name           = module.misc.sbus_extr_queue_name
  sbus_extr_namespace_id         = module.misc.sbus_extr_namespace_id
  sbus_extr_namespace_name       = module.misc.sbus_extr_namespace_name
  sbus_extr_namespace_connection = module.misc.sbus_extr_namespace_connection
  func_app_insights_conn_string  = var.func_app_insights_conn_string
  func_app_insights_key          = var.func_app_insights_key
  psql_app_insights_conn_string  = var.psql_app_insights_conn_string
  psql_app_insights_key          = var.psql_app_insights_key
}

#######################
###### Storage ########
#######################

module "storage" {
  source                   = "./modules/storage"
  rg_name                  = var.rg_name
  location                 = var.location
  account_replication_type = var.account_replication_type
  acr_name                 = var.acr_name
  acr_scope_map_name       = var.acr_scope_map_name
  acr_sku                  = var.acr_sku
  acr_token_name           = var.acr_token_name
  container_access_type    = var.container_access_type
  key_vault_key_name       = var.key_vault_key_name
  key_vault_name           = var.key_vault_name
  key_vault_sku            = var.key_vault_sku
  prefix                   = var.prefix
  private_cidr_psql        = module.networking.private_cidr_psql
  private_sub_id           = module.networking.private_sub_id
  private_sub_id_psql      = module.networking.private_sub_id_psql
  psql_db_name             = var.psql_db_name
  psql_server_name         = var.psql_server_name
  psql_sku_name            = var.psql_sku_name
  psql_storage_size        = var.psql_storage_size
  public_sub_id            = module.networking.public_sub_id
  pvt_dns_zone_id          = module.misc.pvt_dns_zone_id
  storage_account_name     = var.storage_account_name
  storage_account_tier     = var.storage_account_tier
  storage_blob_name        = var.storage_blob_name
  storage_blob_type        = var.storage_blob_type
  storage_container_name   = var.storage_container_name
}

#######################
##### Monitoring ######
#######################

module "monitoring" {
  source   = "./modules/monitoring"
  rg_name  = var.rg_name
  location = var.location
  # doc_proc_id = module.functions.doc_proc_id
  # doc_extr_id = module.functions.doc_extractor_id
  # doc_proc_app_id = module.functions.doc_proc_app_id
  # doc_extr_app_id = module.functions.doc_extr_app_id
  psql_server_id = module.storage.psql_server_id
  psql_db_id     = module.storage.psql_db_id
}

#######################
#### Miscellaneous ####
#######################

module "misc" {
  source             = "./modules/misc"
  rg_name            = var.rg_name
  location           = var.location
  prefix             = var.prefix
  virtual_network_id = module.networking.vnet_id
  sbus_namespace_sku = var.sbus_namespace_sku
  # doc_proc_principal_id = module.functions.doc_proc_principal_id
  # doc_ext_principal_id  = module.functions.doc_ext_principal_id
}