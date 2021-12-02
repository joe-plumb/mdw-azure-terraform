resource "azurerm_storage_account" "sharedblob" {
  name                     = "mdw-shared-01"
  resource_group_name      = azurerm_resource_group.rg_shared.name
  location                 = azurerm_resource_group.rg_shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "false"
  tags = var.default_tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "synapse"
  storage_account_name  = azurerm_storage_account.sharedblob.name
  container_access_type = "private"
}