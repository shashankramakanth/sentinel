# AKS Terraform Resource Plan

This folder should contain Terraform code to provision an Azure Kubernetes Service (AKS) platform and its supporting Azure resources.

## Core resources to create

| Area | Terraform resource type(s) | Purpose |
|---|---|---|
| Resource group | `azurerm_resource_group` | Logical container for AKS and related resources. |
| Networking | `azurerm_virtual_network`, `azurerm_subnet`, `azurerm_network_security_group`, `azurerm_subnet_network_security_group_association` | Dedicated network and subnet boundaries for AKS nodes and traffic controls. |
| AKS cluster | `azurerm_kubernetes_cluster` | Creates the managed Kubernetes control plane and default node pool. |
| Additional node pools | `azurerm_kubernetes_cluster_node_pool` | Supports workload isolation (system/user/gpu/spot pools). |
| Identity and access | `azurerm_user_assigned_identity`, `azurerm_role_assignment` | Grants AKS required permissions for networking, registry pull, and managed services. |
| Container registry | `azurerm_container_registry`, `azurerm_role_assignment` | Stores container images and grants AKS pull access. |
| Monitoring | `azurerm_log_analytics_workspace`, `azurerm_monitor_diagnostic_setting` | Captures AKS logs, metrics, and diagnostics. |

## Recommended supporting resources

| Area | Terraform resource type(s) | Purpose |
|---|---|---|
| Public ingress IP | `azurerm_public_ip` | Static public IP for ingress controller or load balancer. |
| Private DNS (for private AKS) | `azurerm_private_dns_zone`, `azurerm_private_dns_zone_virtual_network_link` | Enables private cluster API DNS resolution. |
| Key management | `azurerm_key_vault`, `azurerm_role_assignment` | Centralized secrets and key material management. |
| Route control (if using UDR) | `azurerm_route_table`, `azurerm_subnet_route_table_association` | Custom routing for controlled egress patterns. |
| NAT egress (optional) | `azurerm_nat_gateway`, `azurerm_subnet_nat_gateway_association`, `azurerm_public_ip_prefix` | Stable outbound IPs and scalable egress. |

## Typical AKS capabilities to configure in `azurerm_kubernetes_cluster`

- Kubernetes version and automatic upgrades policy
- Cluster identity (`SystemAssigned` or `UserAssigned`)
- Network profile (CNI mode, service CIDR, DNS service IP, outbound type)
- RBAC and Microsoft Entra ID integration
- Azure Policy and Defender profile (if required)
- OIDC issuer and workload identity (if required)
- Auto-scaling settings for node pools

## Suggested implementation order

1. Create resource group and networking.
2. Create log analytics workspace and supporting monitoring resources.
3. Create identities and role assignments.
4. Create container registry and grant AKS pull permissions.
5. Create AKS cluster and additional node pools.
6. Add optional ingress, DNS, key vault, and egress controls.
