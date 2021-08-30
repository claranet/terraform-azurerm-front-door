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
