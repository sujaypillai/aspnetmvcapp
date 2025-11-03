variable "location" {
  description = "Azure region for all resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace supporting Container Apps diagnostics."
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Retention period (in days) for Log Analytics data."
  type        = number
  default     = 30
}

variable "acr_name" {
  description = "Globally unique Azure Container Registry name."
  type        = string
}

variable "acr_sku" {
  description = "Azure Container Registry SKU."
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "acr_sku must be one of Basic, Standard, or Premium."
  }
}

variable "container_apps_environment_name" {
  description = "Name of the Azure Container Apps environment."
  type        = string
}

variable "container_app_name" {
  description = "Name of the Azure Container App."
  type        = string
}

variable "container_app_image" {
  description = "Container image (including tag) to deploy (e.g. acr.azurecr.io/aspnetmvcapp:latest)."
  type        = string
}

variable "container_app_target_port" {
  description = "Internal port exposed by the container."
  type        = number
  default     = 8080
}

variable "container_app_ingress_external" {
  description = "Expose the container app via an external endpoint."
  type        = bool
  default     = true
}

variable "container_app_ingress_transport" {
  description = "Transport protocol for ingress (auto, http, https)."
  type        = string
  default     = "auto"
  validation {
    condition     = contains(["auto", "http", "https"], var.container_app_ingress_transport)
    error_message = "container_app_ingress_transport must be one of auto, http, or https."
  }
}

variable "container_cpu" {
  description = "CPU cores allocated to the container."
  type        = number
  default     = 0.25
}

variable "container_memory" {
  description = "Memory allocated to the container (Gi format)."
  type        = string
  default     = "0.5Gi"
}

variable "container_app_min_replicas" {
  description = "Minimum number of container replicas."
  type        = number
  default     = 1
}

variable "container_app_max_replicas" {
  description = "Maximum number of container replicas."
  type        = number
  default     = 3
}

variable "container_app_scale_rules" {
  description = "List of scaling rules passed to the container app module."
  type        = list(any)
  default     = []
}

variable "container_app_environment_variables" {
  description = "Environment variables injected into the container definition."
  type = list(object({
    name      = string
    value     = optional(string)
    secretRef = optional(string)
  }))
  default = []
}

variable "container_app_revision_mode" {
  description = "Revision mode for the container app (Single or Multiple)."
  type        = string
  default     = "Single"
  validation {
    condition     = contains(["Single", "Multiple"], var.container_app_revision_mode)
    error_message = "container_app_revision_mode must be Single or Multiple."
  }
}

variable "container_app_traffic_weights" {
  description = "Optional traffic weight configuration when using multiple revisions."
  type = list(object({
    latest_revision = optional(bool)
    revision        = optional(string)
    weight          = number
  }))
  default = []
}

variable "infrastructure_subnet_id" {
  description = "Optional subnet resource ID for workload profiles. Leave null for consumption environments."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
