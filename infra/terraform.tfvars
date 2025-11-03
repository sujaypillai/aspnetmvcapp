location                         = "southeastasia"
resource_group_name              = "rg-aspnetmvcapp"
log_analytics_workspace_name     = "log-aspnetmvcapp"
acr_name                         = "acraspnetmvcapp"
container_apps_environment_name  = "aspnetmvcapp-env"
container_app_name               = "aspnetmvcapp"
container_app_image              = "acraspnetmvcapp.azurecr.io/aspnetmvcapp:latest"
container_app_target_port        = 8080
container_app_ingress_external   = true
container_app_revision_mode      = "Single"
container_app_min_replicas       = 1
container_app_max_replicas       = 3

tags = {
  application = "aspnetmvcapp"
  owner       = "platform-team"
}
