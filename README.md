# Azure Front Door
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/front-door/azurerm/)

This terraform module is designed to create an [Azure Front Door](https://www.terraform.io/docs/providers/azurerm/r/front_door.html)

## Requirements

* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/)

## Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------| --------------- |
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
  source  = "claranet/front-door/azurerm//modules/frontdoor-waf"
  version = "x.x.x"

  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack

  waf_managed_rules = [{
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

  waf_custom_block_response_body = "files/403.html"
}

module "front-door" {
  source  = "claranet/front-door/azurerm"
  version = "x.x.x"

  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack

  frontdoor_waf_policy_id = module.front-door-waf-policy.waf_policy_id

  enable_default_frontend_endpoint = false

  frontend_endpoints = [
    {
      name                                    = "custom-fo"
      host_name                               = "custom-fo.example.com"
      custom_https_provisioning_enabled       = true
      web_application_firewall_policy_link_id = module.front-door-waf-policy.waf_policy_id
      custom_https_configurations = [
        {
          certificate_source = "FrontDoor"
        }
      ]
    }
  ]

  backend_pools = [{
    name = local.frontdoor_backend_name,
    backends = [{
      host_header = module.app_service.app_service_default_site_hostname
      address     = module.app_service.app_service_default_site_hostname
    }]
  }]

  routing_rules = [{
    name               = "deny-install"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/core/install.php"]

    redirect_configurations = [{
      custom_path       = "/"
      redirect_protocol = "MatchRequest"
      redirect_type     = "Found"
    }]
  }]

}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.60 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend\_pool\_health\_probes | A list of backend\_pool\_health\_probe blocks. | `list(map(string))` | <pre>[<br>  {<br>    "default": "default"<br>  }<br>]</pre> | no |
| backend\_pool\_load\_balancings | A list of backend\_pool\_load\_balancing blocks. | `list(map(string))` | <pre>[<br>  {<br>    "default": "default"<br>  }<br>]</pre> | no |
| backend\_pools | A list of backend\_pool blocks. | `list(any)` | n/a | yes |
| backend\_pools\_send\_receive\_timeout\_seconds | Specifies the send and receive timeout on forwarding request to the backend | `number` | `60` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| diag\_settings\_name | Custom name for the diagnostic settings of Application Gateway. | `string` | `""` | no |
| enable\_default\_backend\_pools\_parameters | Use the module default backend\_pools\_health\_probe and backend\_pools\_load\_balancing blocks. | `bool` | `true` | no |
| enable\_default\_frontend\_endpoint | Use the module default frontend\_endpoint block. | `bool` | `true` | no |
| enable\_default\_routing\_rule | Use the module default routing\_rule block. | `bool` | `true` | no |
| enable\_logging | Boolean flag to specify whether logging is enabled | `bool` | `true` | no |
| enforce\_backend\_pools\_certificate\_name\_check | Enforce certificate name check on HTTPS requests to all backend pools, this setting will have no effect on HTTP requests. | `bool` | `false` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| friendly\_name | A friendly name for the Front Door service. | `string` | `null` | no |
| frontdoor\_waf\_policy\_id | Frontdoor WAF Policy ID | `string` | `null` | no |
| frontend\_endpoints | A list frontend\_endpoint block. | `list(any)` | `[]` | no |
| load\_balancer\_enabled | Should the Front Door Load Balancer be Enabled? | `bool` | `true` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_enable\_metrics | Boolean flag to specify whether collecting metrics is enabled | `bool` | `false` | no |
| logs\_log\_analytics\_workspace\_id | Log Analytics Workspace id for logs | `string` | `null` | no |
| logs\_storage\_account\_id | Storage Account id for logs | `string` | `null` | no |
| logs\_storage\_retention | Retention in days for logs on Storage Account | `number` | `30` | no |
| name | Specifies the name of the Front Door service. | `string` | `""` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| routing\_rules | A routing\_rule block. | `any` | `[]` | no |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| frontdoor\_cname | The host that each frontendEndpoint must CNAME to |
| frontdoor\_frontend\_endpoints | The IDs of the frontend endpoints. |
| frontdoor\_id | The ID of the FrontDoor. |

## Related documentation

Azure Front Door: [docs.microsoft.com/en-us/rest/api/frontdoor/](https://docs.microsoft.com/en-us/rest/api/frontdoor/)

