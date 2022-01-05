locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  default_legacy_name = replace(lower(join("", [var.name_prefix, var.stack, var.client_name, var.environment, "waf"])), "/\\W/", "")
  policy_name         = coalesce(var.custom_name, var.use_caf_naming ? azurecaf_name.frontdoor_waf_policy.result : local.default_legacy_name)
}
