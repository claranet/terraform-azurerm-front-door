locals {
  default_name = replace(lower(join("", [var.name_prefix, var.stack, var.client_name, var.environment, "waf"])), "/\\W/", "")
  policy_name  = coalesce(var.custom_name, local.default_name)

  default_tags = {
    env   = var.environment
    stack = var.stack
  }
}
