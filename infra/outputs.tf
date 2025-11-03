output "resource_group_name" {
  description = "Name of the created resource group."
  value       = module.resource_group.name
}

output "container_registry_login_server" {
  description = "Login server for the Azure Container Registry."
  value       = module.container_registry.login_server
}

output "container_app_environment_id" {
  description = "Resource ID of the Azure Container Apps environment."
  value       = module.container_apps_environment.resource_id
}

output "container_app_fqdn" {
  description = "Fully qualified domain name of the deployed container app."
  value       = module.container_app.fqdn
}

output "container_app_identity_principal_id" {
  description = "Principal ID of the container app system-assigned managed identity."
  value       = module.container_app.system_assigned_identity_principal_id
}
