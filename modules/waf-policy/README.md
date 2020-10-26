## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 >= 2.25 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| enable\_waf | Enable WAF on Front Door | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| waf\_custom\_block\_response\_body | If a custom\_rule block's action type is block, this is the response body. The body must be specified in base64 encoding. | `string` | `"default_403"` | no |
| waf\_custom\_block\_response\_status\_code | If a custom\_rule block's action type is block, this is the response status code. Possible values are 200, 403, 405, 406, or 429. | `number` | `403` | no |
| waf\_custom\_policy\_name | The name of the policy. | `string` | `""` | no |
| waf\_custom\_rules | One or more custom\_rule blocks. | `list(any)` | `[]` | no |
| waf\_managed\_rules | One or more managed\_rule blocks. | `any` | `[]` | no |
| waf\_mode | The firewall policy mode. Possible values are Detection, Prevention. | `string` | `"Prevention"` | no |
| waf\_redirect\_url | If action type is redirect, this field represents redirect URL for the client. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| waf\_policy\_id | The ID of the WAF policy. |
