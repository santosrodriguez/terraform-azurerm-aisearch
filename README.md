# terraform-azurerm-cpd-aisearch

Terraform module for deploying an Azure AI Search service with a system-assigned managed identity and a private endpoint. Public network access is disabled by default; authentication supports both Entra ID and API keys.

## Usage

```hcl
module "aisearch" {
  source = "caresource.pe.jfrog.io/shared-tfmodules-internal__ai/aiservices/azurerm"
  version = "#.#.#"

  resource_group_name = "rg-myapp-eastus2-dev"
  solution_name       = "myapp"
  location            = "eastus2"
  environment         = "dev"

  sku                 = "standard"
  semantic_search_sku = "standard"

  # Optional: allow specific public IPs through the firewall
  public_network_access_enabled = true
  allowed_ips                   = ["203.0.113.10", "198.51.100.0/24"]

  private_endpoint_subnet_id           = "/subscriptions/.../subnets/snet-pe"
  private_endpoint_dns_zone_ids        = ["/subscriptions/.../privateDnsZones/privatelink.search.windows.net"]
  private_endpoint_dns_zone_group_name = "default"

  tags = {
    environment = "dev"
    owner       = "platform-team"
  }
}
```

## Resources Created

| Resource | Description |
|---|---|
| `azurerm_search_service` | Azure AI Search service with system-assigned identity |
| `azurerm_private_endpoint` | Private endpoint for network-isolated access |
| `random_string` | 4-character lowercase suffix appended to the resource name |

## Naming Convention

The search service name follows this pattern:

```
srch-<solution_name>-<location>-<environment>-<random_suffix>
```

Example: `srch-myapp-eastus2-dev-ab3c`

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `resource_group_name` | Resource group for the AI Search service | `string` | — | yes |
| `solution_name` | Solution/project name used in resource naming | `string` | — | yes |
| `environment` | Deployment environment identifier (e.g. dev, int, prd) | `string` | — | yes |
| `location` | Azure region for the service | `string` | `"eastus2"` | no |
| `sku` | SKU for the search service (basic, standard, standard2, standard3, storage_optimized_l1, storage_optimized_l2) | `string` | `"basic"` | no |
| `semantic_search_sku` | SKU for the semantic search capability (free, standard); ignored when `sku` is `free` | `string` | `"free"` | no |
| `private_endpoint_subnet_id` | Subnet ID for the private endpoint | `string` | — | yes |
| `private_endpoint_dns_zone_ids` | List of Private DNS Zone IDs to associate with the private endpoint | `list(string)` | `[".../privatelink.search.windows.net"]` | no |
| `private_endpoint_dns_zone_group_name` | Name of the Private DNS Zone Group | `string` | `"default"` | no |
| `public_network_access_enabled` | Whether public network access is enabled. Must be `true` for `allowed_ips` to take effect | `bool` | `false` | no |
| `allowed_ips` | Public IPv4 addresses/CIDR blocks allowed through the firewall when public network access is enabled | `list(string)` | `[]` | no |
| `tags` | Tags to apply to all resources | `map(string)` | — | yes |

## Outputs

| Name | Description |
|---|---|
| `id` | Resource ID of the AI Search service |
| `name` | Name of the AI Search service |
| `principal_id` | Principal ID of the system-assigned managed identity |
| `private_endpoint_id` | Resource ID of the private endpoint |
| `private_ip_address` | Private IP address of the private endpoint |

## Security

- Public network access is **disabled by default**; it can be enabled via `public_network_access_enabled` to allow specific public IPs (`allowed_ips`) while all other public traffic remains blocked
- Authentication failure mode returns **HTTP 403**
- Local authentication (API keys) is enabled alongside Entra ID
- A **system-assigned managed identity** is provisioned automatically

## Publishing

This module is published to JFrog Artifactory under the `ai` namespace via the GitHub Actions workflow on any `v*.*.*` tag push.

```
namespace : ai
provider  : azurerm
module    : aisearch
```
