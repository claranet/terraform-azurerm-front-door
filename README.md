# Azure Front Door
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/front-door/azurerm/)

This Terraform module is designed to create an [Azure Front Door](https://www.terraform.io/docs/providers/azurerm/r/front_door.html) resource.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "front_door_waf" {
  source  = "claranet/front-door/azurerm//modules/waf-policy"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  resource_group_name = module.rg.resource_group_name

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

  # Custom error page 
  #custom_block_response_body = filebase64("${path.module}/files/403.html")
}

module "front_door" {
  source  = "claranet/front-door/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  resource_group_name = module.rg.resource_group_name

  frontdoor_waf_policy_id = module.front_door_waf.waf_policy_id

  default_frontend_endpoint_enabled = false

  frontend_endpoints = [
    {
      name                                    = "custom-fo"
      host_name                               = "custom-fo.example.com"
      web_application_firewall_policy_link_id = module.front_door_waf.waf_policy_id
      custom_https_configuration = {
        certificate_source = "FrontDoor"
      }
    },
    {
      name                                    = "custom-bo"
      host_name                               = "custom-bo.example.com"
      web_application_firewall_policy_link_id = module.front_door_waf.waf_policy_id
      custom_https_configuration = {
        certificate_source                         = "AzureKeyVault"
        azure_key_vault_certificate_vault_id       = "<key_vault_id>"
        azure_key_vault_certificate_secret_name    = "<key_vault_secret_name>"
        azure_key_vault_certificate_secret_version = "<secret_version>" # optional, use "latest" if not defined
      }
    }
  ]

  backend_pools = [{
    name = "frontdoor_backend_pool_1",
    backends = [{
      host_header = "custom-fo.example.com"
      address     = "1.2.3.4"
    }]
  }]

  routing_rules = [{
    name               = "default"
    frontend_endpoints = ["custom-fo"]
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    forwarding_configurations = [{
      backend_pool_name                     = "frontdoor_backend_pool_1"
      cache_enabled                         = false
      cache_use_dynamic_compression         = false
      cache_query_parameter_strip_directive = "StripAll"
      forwarding_protocol                   = "MatchRequest"
    }]
    },
    {
      name               = "deny-install"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = ["/core/install.php"]

      redirect_configurations = [{
        custom_path       = "/"
        redirect_protocol = "MatchRequest"
        redirect_type     = "Found"
      }]
  }]

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.logs_storage_account_id
  ]
}

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.60 |
| external | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 4.0.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_frontdoor.frontdoor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor) | resource |
| [azurerm_frontdoor_custom_https_configuration.custom_https_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/frontdoor_custom_https_configuration) | resource |
| [external_external.frontdoor_ips](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend\_pool\_health\_probes | A list of backend\_pool\_health\_probe blocks. | `list(map(string))` | <pre>[<br>  {<br>    "default": "default"<br>  }<br>]</pre> | no |
| backend\_pool\_load\_balancings | A list of backend\_pool\_load\_balancing blocks. | `list(map(string))` | <pre>[<br>  {<br>    "default": "default"<br>  }<br>]</pre> | no |
| backend\_pools | A list of backend\_pool blocks. | `list(any)` | n/a | yes |
| backend\_pools\_certificate\_name\_check\_enforced | Enforce certificate name check on HTTPS requests to all backend pools, this setting will have no effect on HTTP requests. | `bool` | `false` | no |
| backend\_pools\_send\_receive\_timeout\_seconds | Specifies the send and receive timeout on forwarding request to the backend | `number` | `60` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_name | Specifies the name of the Front Door service. | `string` | `""` | no |
| default\_backend\_pools\_parameters\_enabled | Use the module default backend\_pools\_health\_probe and backend\_pools\_load\_balancing blocks. | `bool` | `true` | no |
| default\_frontend\_endpoint\_enabled | Use the module default frontend\_endpoint block. | `bool` | `true` | no |
| default\_routing\_rule\_accepted\_protocols | Accepted protocols for default routing rule | `list(string)` | <pre>[<br>  "Http",<br>  "Https"<br>]</pre> | no |
| default\_routing\_rule\_enabled | Use the module default routing\_rule block. | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| friendly\_name | A friendly name for the Front Door service. | `string` | `null` | no |
| frontdoor\_waf\_policy\_id | Frontdoor WAF Policy ID | `string` | `null` | no |
| frontend\_endpoints | A list frontend\_endpoint block. | `list(any)` | `[]` | no |
| load\_balancer\_enabled | Should the Front Door Load Balancer be Enabled? | `bool` | `true` | no |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| routing\_rules | A routing\_rule block. | `any` | `[]` | no |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| frontdoor\_backend\_address\_prefixes\_ipv4 | IPv4 address ranges used by the FrontDoor service backend |
| frontdoor\_backend\_address\_prefixes\_ipv6 | IPv6 address ranges used by the FrontDoor service backend |
| frontdoor\_cname | The host that each frontendEndpoint must CNAME to |
| frontdoor\_firstparty\_address\_prefixes\_ipv4 | IPv4 address ranges used by the FrontDoor service "first party" |
| frontdoor\_firstparty\_address\_prefixes\_ipv6 | IPv6 address ranges used by the FrontDoor service "first party" |
| frontdoor\_frontend\_address\_prefixes\_ipv4 | IPv4 address ranges used by the FrontDoor service frontend |
| frontdoor\_frontend\_address\_prefixes\_ipv6 | IPv6 address ranges used by the FrontDoor service frontend |
| frontdoor\_frontend\_endpoints | The IDs of the frontend endpoints. |
| frontdoor\_id | The ID of the FrontDoor. |
| frontdoor\_name | The name of the FrontDoor |
<!-- END_TF_DOCS -->
## Related documentation

Azure Front Door: [docs.microsoft.com/en-us/rest/api/frontdoor/](https://docs.microsoft.com/en-us/rest/api/frontdoor/)
