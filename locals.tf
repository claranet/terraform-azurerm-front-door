locals {
  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.environment}")

  frontdoor_name                           = coalesce(var.custom_name, join("-", [local.default_name, "fd"]))
  default_frontend_endpoint_name           = local.frontdoor_name
  default_frontend_endpoint_hostname       = format("%s.azurefd.net", local.frontdoor_name)
  default_backend_endpoint_name            = join("-", [coalesce(var.custom_name, local.default_name), "back"])
  default_backend_pool_health_probe_name   = join("-", [coalesce(var.custom_name, local.default_name), "probe"])
  default_backend_pool_load_balancing_name = join("-", [coalesce(var.custom_name, local.default_name), "lb"])

  default_tags = {
    env   = var.environment
    stack = var.stack
  }
}
