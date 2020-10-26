locals {
  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0") : ""
  default_name = join("-", compact([local.name_prefix, var.stack, var.client_name, var.location_short, var.environment]))

  waf_policy_name = (var.waf_custom_policy_name != "" ?
    replace("${var.waf_custom_policy_name}wafpolicy", "/\\W/", "") :
    replace("${local.default_name}wafpolicy", "/\\W/", "")
  )

  custom_waf_custom_block_response_body = (
    var.waf_custom_block_response_body == "default_403" ?
    "${path.module}/files/403.html" : var.waf_custom_block_response_body
  )

  waf_custom_block_response_body = (
    fileexists(local.custom_waf_custom_block_response_body) ?
    filebase64(local.custom_waf_custom_block_response_body) : var.waf_custom_block_response_body
  )

  default_tags = {
    env   = var.environment
    stack = var.stack
  }
}
