resource "azurerm_key_vault" "kv" {
  name                        = "mdw-shared-01"
  location                    = azurerm_resource_group.rg_shared.location
  resource_group_name         = azurerm_resource_group.rg_shared.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get", "list", "set", "delete"
    ]
  }
}

resource "azurerm_key_vault_secret" "storage_key" {
  name         = "storage-key1"
  value        = azurerm_storage_account.sharedblob.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_storage_account.sharedblob]
}

resource "azurerm_key_vault_secret" "tf-ado-syn-spn-client-id" {
  name         = "tf-ado-syn-spn-client-id"
  value        = azuread_service_principal.ado_tf_deployment_sp.object_id
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azuread_service_principal.ado_tf_deployment_sp]
}

resource "azurerm_key_vault_secret" "tf-ado-syn-spn-tenant-id" {
  name         = "tf-ado-syn-spn-tenant-id"
  value        = azuread_service_principal.ado_tf_deployment_sp.application_tenant_id
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azuread_service_principal.ado_tf_deployment_sp]
}

resource "azurerm_key_vault_secret" "tf-ado-syn-spn-client-secret" {
  name         = "tf-ado-syn-spn-client-secret"
  value        = azuread_service_principal_password.ado_tf_deployment_sp.value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azuread_service_principal_password.ado_tf_deployment_sp]
}

resource "azurerm_key_vault_secret" "tf-ado-syn-subscription-id" {
  name         = "tf-ado-syn-subscription-id"
  value        = data.azurerm_subscription.current.id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "tf-ado-syn-admins" {
  name         = "tf-ado-syn-admins"
  value        = azuread_group.tf-ado-syn-admins.object_id
  key_vault_id = azurerm_key_vault.kv.id
}

