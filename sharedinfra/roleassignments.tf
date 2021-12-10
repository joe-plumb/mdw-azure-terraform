resource "azurerm_role_assignment" "tfsp_contrib_ra" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.ado_tf_deployment_sp.object_id
  depends_on = [
    azuread_service_principal.ado_tf_deployment_sp
  ]
}