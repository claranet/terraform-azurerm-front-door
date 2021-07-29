resource "azurerm_frontdoor_firewall_policy" "frontdoor_waf" {
  name                = local.policy_name
  resource_group_name = var.resource_group_name

  enabled                           = var.enabled
  mode                              = var.mode
  redirect_url                      = var.redirect_url
  custom_block_response_status_code = var.custom_block_response_status_code
  custom_block_response_body        = var.custom_block_response_body == null ? filebase64("${path.module}/files/403.html") : var.custom_block_response_body

  tags = merge(local.default_tags, var.extra_tags)

  dynamic "custom_rule" {
    for_each = var.custom_rules
    content {
      # Required
      name   = lookup(custom_rule.value, "name")
      action = lookup(custom_rule.value, "action")
      type   = lookup(custom_rule.value, "type")

      dynamic "match_condition" {
        # for_each = var.waf_custom_rule_match_conditions
        for_each = lookup(custom_rule.value, "match_conditions")
        content {
          # Required
          match_variable = lookup(match_condition.value, "match_variable")
          match_values   = lookup(match_condition.value, "match_values")
          operator       = lookup(match_condition.value, "operator")
          # Optional
          selector           = lookup(match_condition.value, "selector", null)
          negation_condition = lookup(match_condition.value, "negation_condition", null)
          transforms         = lookup(match_condition.value, "transforms", null)
        }
      }

      # Optional
      enabled                        = lookup(custom_rule.value, "enabled", null)
      priority                       = lookup(custom_rule.value, "priority", null)
      rate_limit_duration_in_minutes = lookup(custom_rule.value, "rate_limit_duration_in_minutes", null)
      rate_limit_threshold           = lookup(custom_rule.value, "rate_limit_threshold", null)

    }
  }

  dynamic "managed_rule" {
    for_each = var.managed_rules
    content {
      # Required
      type    = lookup(managed_rule.value, "type")
      version = lookup(managed_rule.value, "version")

      dynamic "override" { # optional
        for_each = lookup(managed_rule.value, "overrides", [])
        content {
          rule_group_name = lookup(override.value, "rule_group_name")

          dynamic "exclusion" {
            for_each = lookup(override.value, "exclusions", [])
            content {
              match_variable = string # required
              operator       = string # required
              selector       = string # required
            }
          }

          dynamic "rule" {
            for_each = lookup(override.value, "rules", [])
            content {
              rule_id = lookup(rule.value, "rule_id")
              action  = lookup(rule.value, "action")
              enabled = lookup(rule.value, "enabled", null)

              dynamic "exclusion" {
                for_each = lookup(override.value, "exclusions", [])
                content {
                  match_variable = string # required
                  operator       = string # required
                  selector       = string # required
                }
              }
            }
          }
        }
      }
    }
  }
}
