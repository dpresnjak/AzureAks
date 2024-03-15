data "azurerm_client_config" "current" {
}
data "azurerm_subscription" "primary" {
}
# Buckets/Storage accounts
resource "azurerm_storage_account" "storage_account" {
  name                      = "${var.prefix}${var.storage_account_name}"
  resource_group_name       = var.rg_name
  location                  = var.location
  account_tier              = var.storage_account_tier
  account_replication_type  = var.account_replication_type
  shared_access_key_enabled = true
}
resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.container_access_type
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = "${var.prefix}-${var.storage_blob_name}"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = var.storage_blob_type
}


resource "azurerm_user_assigned_identity" "acr_identity" {
  resource_group_name = var.rg_name
  location            = var.location
  name                = "${var.prefix}-acr-identity"
}

##################################
#### Roles & role assignments ####
##################################

resource "azurerm_role_assignment" "acr_identity_role" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.acr_identity.principal_id
  #skip_service_principal_aad_check = true
  #principal_type = "User"
}
resource "azurerm_role_assignment" "acr_identity_role_owner" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.acr_identity.principal_id
  #skip_service_principal_aad_check = true
  #principal_type = "User"
}

resource "azurerm_role_assignment" "acr_identity_role_current_admin" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = "4ad445b5-6086-42d1-8c1e-14e8eca605c1" # Currently my ID
  #skip_service_principal_aad_check = true
  #principal_type = "User"
}
resource "azurerm_role_assignment" "acr_identity_role_current_crypto" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = "4ad445b5-6086-42d1-8c1e-14e8eca605c1" # Currently my ID
  #skip_service_principal_aad_check = true
  #principal_type = "User"
}

##################################
###### Container registry ########
##################################

resource "azurerm_container_registry" "acr" {
  name                          = "${var.prefix}${var.acr_name}"
  resource_group_name           = var.rg_name
  location                      = var.location
  sku                           = var.acr_sku
  admin_enabled                 = true
  public_network_access_enabled = true
  data_endpoint_enabled         = true
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.acr_identity.id
    ]
  }
  encryption {
    enabled            = true
    key_vault_key_id   = azurerm_key_vault_key.acr_key.id
    identity_client_id = azurerm_user_assigned_identity.acr_identity.client_id
  }
  # georeplications { # Only works with Premium sku
  #   location = "East US"
  #   zone_redundancy_enabled = true
  #   tags = {}
  # }
  # georeplications {
  #   location = "North Europe"
  #   zone_redundancy_enabled = true
  #   tags = {}
  # }
}

resource "azurerm_container_registry_scope_map" "acr_scope" {
  name                    = "${var.prefix}${var.acr_scope_map_name}"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.rg_name
  actions = [
    "repositories/trigger/content/delete",
    "repositories/trigger/content/read",
    "repositories/trigger/content/write",
    "repositories/trigger/content/metadata/read",
    "repositories/trigger/content/metadata/write",
    "repositories/gateway/content/delete",
    "repositories/gateway/content/read",
    "repositories/gateway/content/write",
    "repositories/gateway/metadata/read",
    "repositories/gateway/metadata/write"
  ]
}

resource "azurerm_container_registry_token" "acr_token" {
  name                    = "${var.prefix}${var.acr_token_name}"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.rg_name
  scope_map_id            = azurerm_container_registry_scope_map.acr_scope.id
}

# resource "azurerm_container_connected_registry" "acr_connection" {
#   name = "dpresacrconnection"
#   container_registry_id = azurerm_container_registry.acr.id
#   sync_token_id = azurerm_container_registry_token.acr_token.id
# }

#######################
###### Key Vault ######
#######################

resource "azurerm_key_vault" "key_vault" {
  name                        = "${var.prefix}-${var.key_vault_name}"
  location                    = var.location
  resource_group_name         = var.rg_name
  enabled_for_disk_encryption = true
  enabled_for_deployment      = true
  enable_rbac_authorization   = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = var.key_vault_sku
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    virtual_network_subnet_ids = [var.public_sub_id, var.private_sub_id]
  }
}

# If this fails:
# Key vault -> Access contorl -> Add role assignment owner to deploying logged in user
resource "azurerm_key_vault_key" "acr_key" {
  depends_on = [
    azurerm_role_assignment.acr_identity_role_current_admin,
    azurerm_role_assignment.acr_identity_role_current_crypto,
    azurerm_role_assignment.acr_identity_role,
    azurerm_role_assignment.acr_identity_role_owner
  ]
  name         = "${var.prefix}-${var.key_vault_key_name}"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_size     = "2048"
  key_type     = "RSA"
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]
}

#######################
###### PostgreSQL #####
#######################

resource "azurerm_postgresql_flexible_server" "psql_server" {
  name                   = "${var.prefix}-${var.psql_server_name}"
  resource_group_name    = var.rg_name
  location               = var.location
  version                = "15"
  delegated_subnet_id    = var.private_sub_id_psql
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!" # Not good
  storage_mb             = var.psql_storage_size
  zone                   = 1
  sku_name               = var.psql_sku_name
  private_dns_zone_id    = var.pvt_dns_zone_id
  authentication {
    active_directory_auth_enabled = true
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_postgresql_flexible_server_database" "psql_db" {
  name      = "${var.prefix}${var.psql_db_name}"
  server_id = azurerm_postgresql_flexible_server.psql_server.id
  charset   = "utf8"
  collation = "en_US.utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

# resource "azurerm_postgresql_flexible_server_configuration" "psql_audit_config" {
#   name = "psql-audit"
#   server_id = azurerm_postgresql_flexible_server.psql_server.id
#   value = "pgaudit"
# }