terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

#Supports using Entra ID and API Keys 
resource "azurerm_search_service" "aisearch" {
  name                = "srch-${var.solution_name}-${var.location}-${var.environment}-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  semantic_search_sku =  (lower(var.sku)) != "free" ? var.semantic_search_sku : null

  local_authentication_enabled = true
  authentication_failure_mode  = "http403"

  public_network_access_enabled = var.public_network_access_enabled
  allowed_ips                   = var.allowed_ips

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "aisearch_pep" {
  name = "pe-${azurerm_search_service.aisearch.name}"
  location = azurerm_search_service.aisearch.location
  subnet_id = var.private_endpoint_subnet_id
  resource_group_name = var.resource_group_name
  private_service_connection {
    is_manual_connection = false
    name = "pe-connection-${azurerm_search_service.aisearch.name}"
    private_connection_resource_id = azurerm_search_service.aisearch.id
    subresource_names = [ "searchService" ]
  }
  private_dns_zone_group {
    private_dns_zone_ids = var.private_endpoint_dns_zone_ids
    name = var.private_endpoint_dns_zone_group_name
  }
}
