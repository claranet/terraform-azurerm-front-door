# Azure Front Door WAF policy
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/front-door/azurerm//modules/waf-policy)

This Terraform module is designed to create an [Azure Front Door WAF Policy](https://docs.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-policy-settings) resource.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | >= 2.25 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.frontdoor_waf_policy](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_frontdoor_firewall_policy.frontdoor_waf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_block\_response\_body | If a custom\_rule block's action type is block, this is the response body. The body must be specified in base64 encoding. | `string` | `""` | no |
| custom\_block\_response\_status\_code | If a custom\_rule block's action type is block, this is the response status code. Possible values are 200, 403, 405, 406, or 429. | `number` | `403` | no |
| custom\_name | Custom name for the policy. | `string` | `""` | no |
| custom\_rules | One or more custom\_rule blocks. | `list(any)` | `[]` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| enabled | Enable WAF on Front Door | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| managed\_rules | One or more managed\_rule blocks. | `any` | `[]` | no |
| mode | The firewall policy mode. Possible values are Detection, Prevention. | `string` | `"Prevention"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| redirect\_url | If action type is redirect, this field represents redirect URL for the client. | `string` | `null` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| waf\_policy\_id | The ID of the WAF policy. |
<!-- END_TF_DOCS -->
