variable "resource_group_name" {
  description = "The name of the resource group in which to create the Azure AI Search service."
  type        = string
}

variable "location" {
  description = "The Azure location/region where the Azure AI Search service will be created."
  type        = string
  default     = "eastus2"
}

variable "solution_name" {
  description = "The name of the solution/project for naming resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment identifier used for naming (for example: dev, int, prd)."
  type        = string
}

variable "sku" {
  description = "The SKU for the Azure AI Search service (for example: basic, standard, standard2, standard3, storage_optimized_l1, storage_optimized_l2)."
  type        = string
  default     = "basic"
}
variable "semantic_search_sku" {
  description = "The SKU for the Semantic Search capability of Azure AI Search (for example: free or standard)."
  type        = string
  default     = "free"
}

variable "private_endpoint_dns_zone_ids" {
  description = "List of Private DNS Zone IDs to link with the Private Endpoint."
  type        = list(string)
  default = ["/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/rg-azuredns-prd-01/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net" ]
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet in which to create the Private Endpoint."
  type        = string
}

variable "private_endpoint_dns_zone_group_name" {
  description = "The name of the Private DNS Zone Group for the Private Endpoint."
  type        = string
  default     = "default"
}

variable "tags" {
  type = map(string)
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the Azure AI Search service. Must be true for allowed_ips to take effect."
  type        = bool
  default     = false
}

variable "allowed_ips" {
  description = "List of public IPv4 addresses or CIDR blocks allowed to access the search service over the public interface. Only applied when public_network_access_enabled is true."
  type        = list(string)
  default     = []
}
