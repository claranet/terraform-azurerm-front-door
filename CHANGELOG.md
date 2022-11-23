# v6.1.0 - 2022-11-23

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v6.0.0 - 2022-06-03

Breaking
  * AZ-717: Require Terraform 1.0+
  * AZ-717: Bump AzureRM provider version to `v3.0+`

# v5.1.0 - 2022-04-08

Added
  * AZ-615: Add an option to enable or disable default tags

# v5.0.1 - 2022-02-04

Fixed
  * AZ-572: Fix main example code

# v5.0.0 - 2022-01-14

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

# v4.5.0 - 2022-01-06

Breaking
  * AZ-644: Drop Terraform 0.12 support

Added:
  * AZ-644: Output FrontDoor IP ranges

# v4.4.0 - 2021-12-03

Breaking
  * AZ-593: Rework variables

Added
  * AZ-593: Add outputs

Changed
  * AZ-572: Revamp examples and improve CI

Fixed
  * AZ-589: Avoid plan drift when specifying Diagnostic Settings categories

# v4.3.0 - 2021-08-30

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
  * AZ-532: Revamp README with latest `terraform-docs` tool

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
