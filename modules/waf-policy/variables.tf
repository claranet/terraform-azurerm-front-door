variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "enable_waf" {
  description = "Enable WAF on Front Door"
  type        = bool
  default     = true
}

variable "waf_custom_policy_name" {
  description = "The name of the policy."
  type        = string
  default     = ""
}

variable "waf_mode" {
  description = "The firewall policy mode. Possible values are Detection, Prevention."
  type        = string
  default     = "Prevention"
}

variable "waf_redirect_url" {
  description = "If action type is redirect, this field represents redirect URL for the client."
  type        = string
  default     = null
}

variable "waf_custom_rules" {
  description = "One or more custom_rule blocks."
  type        = list(any)
  # type = list(object({
  #   name     = string # required
  #   action   = string # required
  #   enabled  = bool   # optional
  #   priority = number # required but default to 1 ?!
  #   type     = string # required
  #   match_condition = object({
  #     match_variable     = string # required
  #     match_values       = list   # required
  #     operator           = string # required
  #     selector           = string # optional
  #     negation_condition = bool   # optional default to false ?
  #     transforms         = list   # optional
  #   })
  #   rate_limit_duration_in_minutes = number # optional - defaults to 1
  #   rate_limit_threshold           = number # optional - defaults to 10
  # }))
  default = []
}

#variable "waf_custom_rule_match_conditions" {
#  description = ""
#  type        = list(map(string))
#  default     = []
#}

variable "waf_custom_block_response_status_code" {
  description = "If a custom_rule block's action type is block, this is the response status code. Possible values are 200, 403, 405, 406, or 429."
  type        = number
  default     = 403
}

variable "waf_custom_block_response_body" {
  description = "If a custom_rule block's action type is block, this is the response body. The body must be specified in base64 encoding."
  type        = string
  default     = "default_403"
}

variable "waf_managed_rules" {
  description = "One or more managed_rule blocks."
  type        = any
  # type = list(object({
  #   type    = string          # required
  #   version = string          # required
  #   exclusion = object({      # optional
  #     match_variable = string # required
  #     operator       = string # required
  #     selector       = string # required
  #   })
  #   override = object({         # optional
  #     rule_group_name = string  # required
  #     exclusion = object({      # optional
  #       match_variable = string # required
  #       operator       = string # required
  #       selector       = string # required
  #     })
  #     rule = object({             # optional
  #       rule_id = string          # required
  #       action  = string          # required
  #       enabled = bool            # optional
  #       exclusion = object({      # optional
  #         match_variable = string # required
  #         operator       = string # required
  #         selector       = string # required
  #       })
  #     })
  #   })
  # }))
  default = []
}

