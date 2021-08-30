# Azure Front Door WAF policy
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/front-door/azurerm//modules/waf-policy)

This Terraform module is designed to create an [Azure Front Door WAF Policy](https://docs.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-policy-settings) resource.

## Requirements

* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/)

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.25         |
| >= 4.x.x       | 0.13.x            | >= 2.25         |
| >= 3.x.x       | 0.12.x            | >= 2.25         |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "front-door-waf" {
  source  = "claranet/front-door/azurerm//modules/waf-policy"
  version = "x.x.x"

  resource_group_name = module.rg.resource_group_name
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack

  managed_rules = [{
    type    = "DefaultRuleSet"
    version = "1.0"
    overrides = [{
      rule_group_name = "PHP"
      rules = [{
        action  = "Block"
        enabled = false
        rule_id = 933111
      }]
    }]
    }, {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }]

  custom_block_response_body = filebase64("${path.module}/files/403.html")
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.25 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_frontdoor_firewall_policy.frontdoor_waf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_block\_response\_body | If a custom\_rule block's action type is block, this is the response body. The body must be specified in base64 encoding. | `string` | `""` | no |
| custom\_block\_response\_status\_code | If a custom\_rule block's action type is block, this is the response status code. Possible values are 200, 403, 405, 406, or 429. | `number` | `403` | no |
| custom\_name | Custom name for the policy. | `string` | `""` | no |
| custom\_rules | One or more custom\_rule blocks. | `list(any)` | `[]` | no |
| enabled | Enable WAF on Front Door | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| managed\_rules | One or more managed\_rule blocks. | `any` | `[]` | no |
| mode | The firewall policy mode. Possible values are Detection, Prevention. | `string` | `"Prevention"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| redirect\_url | If action type is redirect, this field represents redirect URL for the client. | `string` | `null` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| waf\_policy\_id | The ID of the WAF policy. |
<!-- END_TF_DOCS -->