provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    client_id = var.spn-client-id
    client_secret = var.spn-client-secret
    tenant_id = var.spn-tenant-id
}