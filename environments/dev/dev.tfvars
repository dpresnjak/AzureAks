#### Global
location = "North Europe"
rg_name  = "dev-example"

#### AKS
prefix             = "dev"
node_count         = 2
#aks_agent_vm_size  = "Standard_D2_v2" # https://learn.microsoft.com/en-us/azure/virtual-machines/sizes
aks_agent_vm_size  = "Standard_D4s_v3"
aks_cluster_name   = "aks-cluster"
admin_username     = "azureadmin"
aks_service_cidr   = "10.1.0.0/16"
aks_dns_service_ip = "10.1.0.10"
# aks_docker_bridge_cidr              = "172.17.0.1/16"
# aks_agent_count                     = 3
# aks_kubernetes_version              = "1.14.6"

#### App Gateway
appgw_name       = "AppGateway"
appgw_probe_host = "dpres-test.eastus.cloudapp.azure.com"
appgw_sku_name   = "Standard_v2"
appgw_sku_tier   = "Standard_v2"
appgw_capacity   = 2

#### Misc
sbus_namespace_sku = "Standard"

#### Networking
virtual_network_address_prefix = "10.0.0.0/24"
public_subnet_prefix           = "10.0.0.0/26"
private_subnet_prefix          = "10.0.0.128/25"
psql_private_subnet_prefix     = "10.0.0.64/26"

#### Storage
storage_account_name     = "storageacc4321" # Only lowercase letters and numbers
storage_account_tier     = "Standard"
account_replication_type = "GRS"
storage_container_name   = "container-4321" # Only lowercase and hyphens
container_access_type    = "private"
storage_blob_name        = "blob_4321"
storage_blob_type        = "Block"
acr_name                 = "containerregistry" # Alphanumberic only
acr_sku                  = "Premium"
acr_scope_map_name       = "scopemap"
acr_token_name           = "acrtoken"
key_vault_name           = "keyvault-4321" # Alphanumeric and hyphens
key_vault_sku            = "standard"
key_vault_key_name       = "acr-vault-key"
psql_server_name         = "psql-server"
psql_sku_name            = "B_Standard_B1ms"
psql_storage_size        = 32768
psql_db_name             = "psql_db"

# # Azure subscription ID and tenant ID to create resources
# subscription_id                     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# tenant_id                           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# # Azure AD Service Principal to run Terraform (requires Owner Role). 
# # To create, run: az ad sp create-for-rbac --role="Owner" --scopes="/subscription_ids/<YOUR_SUBSCRIPTION_ID>"
# client_id                           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# client_secret                       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 

# # Certificate to import to Application Gateway parameters
# # The certificate should be in the same directory or include the path
# certificate_name                    = "appgw"
# certificate_path                    = "appgw.pfx"
# certificate_pwd                     = "Azure123456!"