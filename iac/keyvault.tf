resource "azurerm_key_vault" "kv" {
  name                        = "kvsyn${var.env}${var.region}${random_string.random.result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
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

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_synapse_workspace.synapseworkspace.identity[0].principal_id

    secret_permissions = [
      "get", "list", "set"
    ]
  }
  depends_on = [azurerm_synapse_sql_pool.synapsepool]
}

resource "azurerm_key_vault_secret" "kv" {
  name         = "sqlpoolconn"
  value        = "Server=tcp:${azurerm_synapse_workspace.synapseworkspace.name}.database.windows.net,1433;Initial Catalog=${azurerm_synapse_sql_pool.synapsepool.name};Persist Security Info=False;User ID=sqladminuser;Password=${random_password.password.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "kvs_rg" {
  name         = "rgname"
  value        = azurerm_resource_group.rg.name
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "kvs_synws" {
  name         = "synwsname"
  value        = azurerm_synapse_workspace.synapseworkspace.name
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "kvs_syndb" {
  name         = "dwname"
  value        = azurerm_synapse_sql_pool.synapsepool.name
  key_vault_id = azurerm_key_vault.kv.id
}