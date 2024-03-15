## Azure Container Repository
output "acr_url" {
  value = azurerm_container_registry.acr.login_server
}
output "acr_username" {
  value = azurerm_container_registry.acr.admin_username
}
output "acr_password" {
  value = azurerm_container_registry.acr.admin_password
}
output "acr_client_id" {
  value = azurerm_container_registry.acr.identity.0.principal_id
}
output "acr_id" {
  value = azurerm_container_registry.acr.id
}

## Storage Account
output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}
output "storage_access_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}
output "storage_container_name" {
  value = azurerm_storage_container.storage_container.name
}
output "identity_client_id" {
  value = azurerm_user_assigned_identity.acr_identity.client_id
}

## Azure Key Vault
output "key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}
output "key_vault_uri" {
  value = azurerm_key_vault.key_vault.vault_uri
}
output "key_vault_key_id" {
  value = azurerm_key_vault_key.acr_key.id
}

## PSQL
output "psql_server_id" {
  value = azurerm_postgresql_flexible_server.psql_server.id
}
output "psql_db_id" {
  value = azurerm_postgresql_flexible_server_database.psql_db.id
}