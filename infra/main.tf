terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.19.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "log_analytics" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = ">= 0.3.0"

  name                                      = var.log_analytics_workspace_name
  location                                  = var.location
  resource_group_name                       = module.resource_group.name
  log_analytics_workspace_retention_in_days = var.log_analytics_retention_days
  tags                                      = var.tags
}

module "container_registry" {
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = ">= 0.2.0"

  name                          = var.acr_name
  location                      = var.location
  resource_group_name           = module.resource_group.name
  sku                           = var.acr_sku
  admin_enabled                 = false
  public_network_access_enabled = true
  tags                          = var.tags
}

module "container_apps_environment" {
  source  = "Azure/avm-res-app-managedenvironment/azurerm"
  version = ">= 0.2.0"

  name                                = var.container_apps_environment_name
  location                            = var.location
  resource_group_name                 = module.resource_group.name
  log_analytics_workspace_customer_id = module.log_analytics.resource_id
  infrastructure_subnet_id            = var.infrastructure_subnet_id
  internal_load_balancer_enabled      = false
  tags                                = var.tags
}

module "container_app" {
  source  = "Azure/avm-res-app-containerapp/azurerm"
  version = ">= 0.3.0"

  name                                  = var.container_app_name
  location                              = var.location
  resource_group_name                   = module.resource_group.name
  container_app_environment_resource_id = module.container_apps_environment.resource_id
  revision_mode                         = var.container_app_revision_mode
  tags                                  = var.tags

  template = {
    containers = [
      {
        name   = "app"
        image  = var.container_app_image
        cpu    = var.container_cpu
        memory = var.container_memory
        probes = []
        env    = var.container_app_environment_variables
      }
    ]
    scale = {
      min_replicas = var.container_app_min_replicas
      max_replicas = var.container_app_max_replicas
      rules        = var.container_app_scale_rules
    }
  }

  ingress = {
    external_enabled = var.container_app_ingress_external
    target_port      = var.container_app_target_port
    transport        = var.container_app_ingress_transport
    traffic_weight = length(var.container_app_traffic_weights) > 0 ? var.container_app_traffic_weights : [{
      latest_revision = true
      weight          = 100
    }]
  }

  registries = [
    {
      server   = module.container_registry.resource.login_server
      identity = "SystemAssigned"
    }
  ]

  managed_identities = {
    system_assigned = true
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.container_registry.resource_id
  principal_id         = module.container_app.system_assigned_mi_principal_id
  role_definition_name = "AcrPull"
}
