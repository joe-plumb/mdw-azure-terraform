resource "azuread_application" "ado_tf_deployment_sp" {
  display_name = "ado_tf_deployment_sp"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "ado_tf_deployment_sp" {
  application_id               = azuread_application.ado_tf_deployment_sp.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "ado_tf_deployment_sp" {
  service_principal_id = azuread_service_principal.ado_tf_deployment_sp.object_id
}