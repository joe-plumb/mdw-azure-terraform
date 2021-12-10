output "azuread_service_principal_id" {
  description = "ID of Service Principal"
  value       = azuread_application.ado_tf_deployment_sp.application_id
}

output "azuread_service_principal_secret" {
  description = "secret for Service Principal"
  value       = azuread_application_password.ado_tf_deployment_sp.value
  sensitive = true
}

output "azuread_tenantid" {
  description = "secret for Service Principal"
  value       = data.azurerm_subscription.current.tenant_id
}