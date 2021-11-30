resource "azurerm_resource_group" "rg" {
  name     = "mdw-${var.env}-${var.region}-${random_string.random.result}"
  location = var.region
  tags = var.default_tags
}