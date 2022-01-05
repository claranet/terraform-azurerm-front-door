locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  frontdoor_name                           = coalesce(var.custom_name, azurecaf_name.frontdoor.result)
  default_frontend_endpoint_name           = local.frontdoor_name
  default_frontend_endpoint_hostname       = format("%s.azurefd.net", local.frontdoor_name)
  default_backend_pool_health_probe_name   = azurecaf_name.frontdoor_probe.result
  default_backend_pool_load_balancing_name = azurecaf_name.frontdoor_lb.result
}
