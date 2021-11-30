resource "azurerm_role_assignment" "adf_storage_ra" {
  scope                = azurerm_storage_account.adls.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.synapseworkspace.identity[0].principal_id
}
resource "azurerm_synapse_role_assignment" "synapseadmins" {
  synapse_workspace_id = azurerm_synapse_workspace.synapseworkspace.id
  role_name            = "Synapse Administrator"
  principal_id         = var.tf-ado-syn-admins

  depends_on = [azurerm_synapse_firewall_rule.open-fwr]
}
