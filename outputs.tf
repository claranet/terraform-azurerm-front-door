output "frontdoor_cname" {
  description = "The host that each frontendEndpoint must CNAME to"
  value       = azurerm_frontdoor.frontdoor.cname
}

output "frontdoor_id" {
  description = "The ID of the FrontDoor."
  value       = azurerm_frontdoor.frontdoor.id
}
