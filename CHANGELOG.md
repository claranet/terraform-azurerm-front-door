# Unreleased

Breaking
  * AZ-498: Switch to `azurerm_frontdoor_custom_https_configuration` to manage HTTPS. Read [Migration Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor_custom_https_configuration)
  * AZ-498: azurerm provider >=2.60
  * AZ-160: Unify diagnostics settings on all Claranet modules
  * AZ-535: Removed region from name since service is global
  * AZ-535: Harmonize variables
  * AZ-535: Rework waf-policy submodule

Fixes
  * AZ-535: Fix default frontend endpoint name
  * AZ-535: Add missing tags

# v4.2.0 - 2021-02-26

Added
  * AZ-442: backend\_pools\_send\_receive\_timeout\_seconds parameter

# v3.1.0/v4.1.0 - 2021-01-22

Changed
  * AZ-398: Force lowercase on default generated name

# v3.0.1/v4.0.0 - 2020-11-17

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.0.0 - 2020-10-26

Added
  * AZ-218: Azure Front-Door - First Release
