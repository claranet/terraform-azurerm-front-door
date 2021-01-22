locals {
  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  frontdoor_name                           = var.name != "" ? var.name : join("-", [local.default_name, "fd"])
  default_frontend_endpoint_name           = join("-", [coalesce(var.name, local.default_name), "front"])
  default_backend_endpoint_name            = join("-", [coalesce(var.name, local.default_name), "back"])
  default_hostname                         = join(".", [coalesce(var.name, local.default_name), "azurefd.net"])
  default_backend_pool_health_probe_name   = join("-", [coalesce(var.name, local.default_name), "probe"])
  default_backend_pool_load_balancing_name = join("-", [coalesce(var.name, local.default_name), "lb"])

  diag_settings_name = join("-", [coalesce(var.diag_settings_name, local.default_name), "diag-settings"])

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  frontend_endpoints           = var.frontend_endpoints
  routing_rules                = var.routing_rules
  backend_pool_health_probes   = var.backend_pool_health_probes
  backend_pool_load_balancings = var.backend_pool_load_balancings
  backend_pools                = var.backend_pools
}
