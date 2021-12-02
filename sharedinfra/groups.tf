data "azuread_client_config" "current" {}

resource "azuread_group" "tf-ado-syn-admins" {
  display_name     = "tf-ado-syn-admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}