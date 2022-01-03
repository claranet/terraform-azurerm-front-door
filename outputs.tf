output "frontdoor_name" {
  description = "The name of the FrontDoor"
  value       = azurerm_frontdoor.frontdoor.name
}

output "frontdoor_cname" {
  description = "The host that each frontendEndpoint must CNAME to"
  value       = azurerm_frontdoor.frontdoor.cname
}

output "frontdoor_id" {
  description = "The ID of the FrontDoor."
  value       = azurerm_frontdoor.frontdoor.id
}

output "frontdoor_frontend_endpoints" {
  description = "The IDs of the frontend endpoints."
  value       = azurerm_frontdoor.frontdoor.frontend_endpoints
}

output "frontdoor_address_prefixes_ipv4" {
  description = "IPv4 address ranges used by the FrontDoor service"
  value       = [for ip in jsondecode(data.external.frontdoor_ips.result.addressPrefixes) : ip if length(regexall("\\.", ip)) > 0]
}

output "frontdoor_address_prefixes_ipv6" {
  description = "IPv6 address ranges used by the FrontDoor service"
  value       = [for ip in jsondecode(data.external.frontdoor_ips.result.addressPrefixes) : ip if length(regexall(":", ip)) > 0]
}
