#---------
# Common
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

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

# ------------------
# Front Door

variable "backend_pools_send_receive_timeout_seconds" {
  description = "Specifies the send and receive timeout on forwarding request to the backend"
  type        = number
  default     = 60
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

variable "default_backend_pools_parameters_enabled" {
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

variable "backend_pools_certificate_name_check_enforced" { # required but default value ...
  description = "Enforce certificate name check on HTTPS requests to all backend pools, this setting will have no effect on HTTP requests."
  type        = bool
  default     = false
}

variable "load_balancer_enabled" { # optional
  description = "Should the Front Door Load Balancer be Enabled?"
  type        = bool
  default     = true
}

variable "default_frontend_endpoint_enabled" {
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
  #     azure_key_vault_certificate_vault_id       = string # required if AzureKeyVault
  #     azure_key_vault_certificate_secret_name    = string # required if AzureKeyVault
  #     azure_key_vault_certificate_secret_version = string # required if AzureKeyVault
  #   })
  #   web_application_firewall_policy_link_id = string # optional
  # }))
}

variable "default_routing_rule_enabled" {
  description = "Use the module default routing_rule block."
  type        = bool
  default     = true
}

variable "default_routing_rule_accepted_protocols" {
  description = "Accepted protocols for default routing rule"
  type        = list(string)
  default     = ["Http", "Https"]
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

# ------------------
# Front Door WAF Policy
variable "frontdoor_waf_policy_id" {
  description = "Frontdoor WAF Policy ID"
  type        = string
  default     = null
}
