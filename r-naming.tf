data "azurecaf_name" "frontdoor" {
  name          = var.stack
  resource_type = "azurerm_frontdoor"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.environment, local.name_suffix, var.use_caf_naming ? "" : "fd"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "frontdoor_probe" {
  name          = var.stack
  resource_type = "azurerm_frontdoor"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.environment, local.name_suffix, "probe", var.use_caf_naming ? "" : "fd"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "frontdoor_lb" {
  name          = var.stack
  resource_type = "azurerm_frontdoor"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.environment, local.name_suffix, "lb", var.use_caf_naming ? "" : "fd"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}
