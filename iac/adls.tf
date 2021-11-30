# Azure Data Lake
resource "azurerm_storage_account" "adls" {
  name                     = "stsyn${var.env}${var.regionshort}${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags = var.default_tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "lake-storage-raw" {
  name = "raw"
  storage_account_id = azurerm_storage_account.adls.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "lake-storage-cleansed" {
  name = "cleansed"
  storage_account_id = azurerm_storage_account.adls.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "lake-storage-curated" {
  name = "curated"
  storage_account_id = azurerm_storage_account.adls.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "lake-storage-synapsefs" {
  name = "synapsefs"
  storage_account_id = azurerm_storage_account.adls.id
}