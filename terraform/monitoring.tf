resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.resource_group_name}-law"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
