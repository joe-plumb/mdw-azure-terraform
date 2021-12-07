resource "azurerm_resource_group" "rg_shared" {
  name     = "ej-mdw-shared-01"
  location = "westeurope"
  tags = var.default_tags
}
