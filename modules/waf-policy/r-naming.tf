resource "azurecaf_name" "frontdoor_waf_policy" {
  name          = var.stack
  resource_type = "azurerm_frontdoor_firewall_policy"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.environment, local.name_suffix])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}
