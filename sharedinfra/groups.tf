data "azuread_client_config" "current" {}

resource "azuread_group" "tf-ado-syn-admins" {

  display_name     = "tf-ado-syn-admins"
  mail_enabled     = true
  mail_nickname    = "tfadosynadmins"
  security_enabled = true
  types            = ["Unified"]

  owners = [
    data.azuread_client_config.current.object_id
  ]
}