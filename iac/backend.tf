terraform {
  backend "azurerm" {
    resource_group_name  = "mdw-shared-westeurope-01"
    storage_account_name = "stmdwsharedwesteurope01"
    container_name       = "synapse"
    key                  = "state.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.70.0"
    }
  }
}
data "azurerm_client_config" "current" {
}

