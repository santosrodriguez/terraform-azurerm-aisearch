output "id" {
  description = "The ID of the Azure AI Search service."
  value       = azurerm_search_service.aisearch.id
}

output "name" {
  description = "The name of the Azure AI Search service."
  value       = azurerm_search_service.aisearch.name
}

output "principal_id" {
  description = "The principal ID of the system-assigned managed identity."
  value       = azurerm_search_service.aisearch.identity[0].principal_id
}

output "private_endpoint_id" {
  description = "The ID of the private endpoint."
  value       = azurerm_private_endpoint.aisearch_pep.id
}

output "private_ip_address" {
  description = "The private IP address of the private endpoint."
  value       = azurerm_private_endpoint.aisearch_pep.private_service_connection[0].private_ip_address
}
