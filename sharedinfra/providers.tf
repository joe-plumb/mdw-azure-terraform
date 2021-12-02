terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.44.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.6.0"
    }
  }
}

provider "azurerm" {
    features {}
}

data "azurerm_client_config" "current" {
}