resource "azurerm_role_assignment" "tfsp_contrib_ra" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_application.ado_tf_deployment_sp.application_id

  depends_on = [
    azuread_application.ado_tf_deployment_sp
  ]
}