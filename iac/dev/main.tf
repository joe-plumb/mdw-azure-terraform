terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.44.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "mdw-shared-westeurope-01"
    storage_account_name  = "stmdwsharedwesteurope01"
    container_name        = "mdwtfstate"
    key                   = "dev.tfstate"
  }
}

data "azurerm_client_config" "current" {
}

provider "azurerm" {
    features {}
}

resource "random_string" "random" {
  length = 6
  special = false
  upper = false
}

resource "azurerm_resource_group" "rg" {
  name     = "mdw-${var.env}-${var.region}-${random_string.random.result}"
  location = var.region
  tags = var.default_tags
}

# Data Factory
resource "azurerm_data_factory" "adf" {
  name                = "adf-mdw-${var.env}-${var.region}-${random_string.random.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.default_tags
  
  identity {
    type = "SystemAssigned"
  }

  vsts_configuration {
            account_name    = "jpazuredev"
            branch_name     = "main" 
            project_name    = "moderndatawarehouse"
            repository_name = "mdw-azure-terraform" 
            root_folder     = "/adf" 
            tenant_id       = data.azurerm_client_config.current.tenant_id  
  }

}

# Azure Data Lake
resource "azurerm_storage_account" "adls" {
  name                     = "stmdw${var.env}${var.regionshort}${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags = var.default_tags
}

module "lake-storage-raw" {
  source = "../modules/adlscontainercreate"
  existing_resource_group = azurerm_resource_group.rg.name
  existing_storage_account = azurerm_storage_account.adls
  create_container_name = "raw"
}

module "lake-storage-cleansed" {
  source = "../modules/adlscontainercreate"
  existing_resource_group = azurerm_resource_group.rg.name
  existing_storage_account = azurerm_storage_account.adls
  create_container_name = "cleansed"
}

module "lake-storage-curated" {
  source = "../modules/adlscontainercreate"
  existing_resource_group = azurerm_resource_group.rg.name
  existing_storage_account = azurerm_storage_account.adls
  create_container_name = "curated"
}

module "lake-storage-synfs" {
  source = "../modules/adlscontainercreate"
  existing_resource_group = azurerm_resource_group.rg.name
  existing_storage_account = azurerm_storage_account.adls
  create_container_name = "synapsefs"
}

# Synapse

resource "random_password" "password" {
  length = 24
  special = true
  override_special = "_%@"
}

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

resource "azurerm_synapse_firewall_rule" "synfwr" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.synapseworkspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"

  depends_on = [azurerm_synapse_sql_pool.synapsepool]
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "kvmdw${var.env}${var.region}${random_string.random.result}"
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
    object_id = azurerm_data_factory.adf.identity.0.principal_id

    secret_permissions = [
      "get", "list", "set"
    ]
  }
  depends_on = [azurerm_synapse_sql_pool.synapsepool, azurerm_data_factory.adf]
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

resource "azurerm_key_vault_secret" "kvs_adf" {
  name         = "adfname"
  value        = azurerm_data_factory.adf.name
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

# Role assignments
resource "azurerm_role_assignment" "adf_storage_ra" {
  scope                 = azurerm_storage_account.adls.id 
  role_definition_name  = "Storage Blob Data Contributor"
  principal_id          = azurerm_data_factory.adf.identity[0].principal_id
}
