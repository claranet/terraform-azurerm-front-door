#---------
# Common
variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
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

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

# ------------------
# Front Door
variable "name" {
  description = "Specifies the name of the Front Door service."
  type        = string
  default     = ""
}

variable "backend_pools" {
  description = "A list of backend_pool blocks."
  type        = list(any)
  #type = list(object({
  #  name = string          # required
  #  backend = object({     # required
  #    enabled     = bool   # optional defaults to true
  #    address     = string # required
  #    host_header = string # required
  #    http_port   = number # required module-defaults to 80
  #    https_port  = number # required module-defaults to 443
  #    priority    = number # optional defaults to 1
  #    weight      = number # optional defaults to 50
  #  })
  #  load_balancing_name = string # required
  #  health_probe_name   = string # required
  #}))
}

variable "enable_default_backend_pools_parameters" {
  description = "Use the module default backend_pools_health_probe and backend_pools_load_balancing blocks."
  type        = bool
  default     = true
}

variable "backend_pool_health_probes" { # required
  description = "A list of backend_pool_health_probe blocks."
  type        = list(map(string)) # name = string         # required
  #                               # enabled = bool        # optional defaults to true
  #                               # path = string         # optional defaults to /
  #                               # protocol = string     # optional defaults to Http
  #                               # probe_method = string # optional defaults to Get
  default = [{ "default" = "default" }] # fake list of map, if enable_default_backend_pools_parameters take default probe values
}

variable "backend_pool_load_balancings" { # required
  description = "A list of backend_pool_load_balancing blocks."
  type        = list(map(string)) # name = string                            # required
  #                               # sample_size = number                     # optional defaults to 4
  #                               # successful_samples_required = number     # optional defaults to 2
  #                               # additional_latency_milliseconds = number # defaults to 0
  default = [{ "default" = "default" }] # fake list of map, if enable_default_backend_pools_parameters take default lb values
}

variable "enforce_backend_pools_certificate_name_check" { # required but default value ...
  description = "Enforce certificate name check on HTTPS requests to all backend pools, this setting will have no effect on HTTP requests."
  type        = bool
  default     = false
}

variable "load_balancer_enabled" { # optional
  description = "Should the Front Door Load Balancer be Enabled?"
  type        = bool
  default     = true
}

variable "friendly_name" { # optional
  description = "A friendly name for the Front Door service."
  type        = string
  default     = null
}

variable "enable_default_frontend_endpoint" {
  description = "Use the module default frontend_endpoint block."
  type        = bool
  default     = true
}

variable "frontend_endpoints" { # required but claranet by default use default_frontend_endpoint
  description = "A list frontend_endpoint block."
  type        = list(any)
  default     = []
  # type = list(object({
  #   name                              = string # required
  #   host_name                         = string # required
  #   session_affinity_enabled          = bool   # optional defaults to false
  #   session_affinity_ttl_seconds      = number # optional defaults to 0
  #   custom_https_provisioning_enabled = bool   # required defaults to ??
  #   custom_https_configuration = object({
  #     certificate_source                         = string # optional
  #     azure_key_vault_certificate_id             = string # required if AzureKeyVault
  #     azure_key_vault_certificate_secret_name    = string # required if AzureKeyVault
  #     azure_key_vault_certificate_secret_version = string # required if AzureKeyVault
  #   })
  #   web_application_firewall_policy_link_id = string # optional
  # }))
}

variable "enable_default_routing_rule" {
  description = "Use the module default routing_rule block."
  type        = bool
  default     = true
}

variable "routing_rules" { # required but claranet by default use default_routing_rule
  description = "A routing_rule block."
  type        = any
  default     = []
  # type = list(object({
  #   name               = string                      # required
  #   frontend_endpoints = string                      # required
  #   accepted_protocols = list                        # optional
  #   patterns_to_match  = list                        # optional - defaults to /*
  #   enabled            = bool                        # optional - defaults to true
  #   forwarding_configurations = object({             # optional
  #     backend_pool_name                     = string # required
  #     cache_enabled                         = bool   # optional - defaults to false
  #     cache_use_dynamic_compression         = bool   # optional - defaults to false
  #     cache_query_parameter_strip_directive = bool   # optional - defaults to StripAll
  #     custom_forwarding_path                = string # optional
  #     forwarding_protocol                   = string # optional - defaults to HttpsOnly
  #   })
  #   redirect_configurations = object({ # optional
  #     custom_host         = string     # optional
  #     redirect_protocol   = string     # optional - defaults to MatchRequest
  #     redirect_type       = string     # optional defaults to Found
  #     custom_fragment     = string     # optional
  #     custom_path         = string     # optional
  #     custom_query_string = string     # optional
  #   })
  # }))
}

#variable "routing_rules_forwarding_configurations" {
#  description = "A forwarding_configuration block."
#  type        = list(map(string))
#  default     = []
#}
#
#variable "routing_rules_redirect_configurations" {
#  description = "A redirect_configuration block."
#  type        = list(map(string))
#  default     = []
#}
#
#variable "custom_https_configurations" {
#  description = "A list of custom_https_configuration blocks"
#  type        = list(map(string)) # certificate_source = string                         # optional
#  #                               # azure_key_vault_certificate_id = string             # required if AzureKeyVault
#  #                               # azure_key_vault_certificate_secret_name = string    # required if AzureKeyVault
#  #                               # azure_key_vault_certificate_secret_version = string # required if AzureKeyVault
#  default = null
#}

# ------------------
# Front Door WAF Policy
variable "frontdoor_waf_policy_id" {
  description = "Frontdoor WAF Policy ID"
  type        = string
  default     = null
}

#-------------
# LOGGING
variable "enable_logging" {
  description = "Boolean flag to specify whether logging is enabled"
  type        = bool
  default     = true
}

variable "diag_settings_name" {
  description = "Custom name for the diagnostic settings of Application Gateway."
  type        = string
  default     = ""
}

variable "logs_enable_metrics" {
  description = "Boolean flag to specify whether collecting metrics is enabled"
  type        = bool
  default     = false
}

variable "logs_storage_retention" {
  description = "Retention in days for logs on Storage Account"
  type        = number
  default     = 30
}

variable "logs_storage_account_id" {
  description = "Storage Account id for logs"
  type        = string
  default     = null
}

variable "logs_log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for logs"
  type        = string
  default     = null
}

