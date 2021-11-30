resource "azurerm_synapse_workspace" "synapseworkspace" {
  name                                 = "syn${var.env}${var.regionshort}${random_string.random.result}"
  resource_group_name                  = azurerm_resource_group.rg.name
  location                             = azurerm_resource_group.rg.location
  storage_data_lake_gen2_filesystem_id = "https://${azurerm_storage_account.adls.name}.dfs.core.windows.net/synapsefs"
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = random_password.password.result
  tags = var.default_tags
  depends_on = [azurerm_storage_account.adls]
}

resource "azurerm_synapse_sql_pool" "synapsepool" {
  name                 = "workloadsyndemo"
  synapse_workspace_id = azurerm_synapse_workspace.synapseworkspace.id
  sku_name             = "DW100c"
  create_mode          = "Default"
  tags = var.default_tags
  depends_on = [azurerm_synapse_workspace.synapseworkspace]
}

resource "azurerm_synapse_spark_pool" "sparkpool" {
  name                 = "workloadsyndemo"
  synapse_workspace_id = azurerm_synapse_workspace.synapseworkspace.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"

  auto_scale {
    max_node_count = 3
    min_node_count = 3
  }

  auto_pause {
    delay_in_minutes = 15
  }
}

resource "azurerm_synapse_firewall_rule" "synfwr" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.synapseworkspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
  depends_on = [azurerm_synapse_sql_pool.synapsepool]
}

resource "azurerm_synapse_firewall_rule" "open-fwr" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.synapseworkspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
  depends_on = [azurerm_synapse_sql_pool.synapsepool]
}