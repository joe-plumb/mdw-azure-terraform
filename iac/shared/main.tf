terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.44.0"
    }
  }
}

# data "azurerm_client_config" "current" {
# }

provider "azurerm" {
    features {}
}

# Shared resources 
# Storage for tf state

resource "azurerm_resource_group" "rg_shared" {
  name     = "mdw-shared-westeurope-01"
  location = "westeurope"
  tags = var.default_tags
}

resource "azurerm_storage_account" "sharedblob" {
  name                     = "stmdwsharedwesteurope01"
  resource_group_name      = azurerm_resource_group.rg_shared.name
  location                 = azurerm_resource_group.rg_shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "false"
  tags = var.default_tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "sharedtfstate"
  storage_account_name  = azurerm_storage_account.sharedblob.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "mdwtfstate" {
  name                  = "mdwtfstate"
  storage_account_name  = azurerm_storage_account.sharedblob.name
  container_access_type = "private"
}
