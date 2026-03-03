resource "azurerm_virtual_network" "aks" {
  name                = "${var.resource_group_name}-vnet"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "aks_nodes_pods" {
  name                 = "${var.resource_group_name}-aks-subnet"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "aks" {
  name                = "${var.resource_group_name}-aks-nsg"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
}

resource "azurerm_subnet_network_security_group_association" "aks_nodes_pods_association" {
  subnet_id                 = azurerm_subnet.aks_nodes_pods.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_subnet" "app_gateway" {
  name                 = "${var.resource_group_name}-appgw-subnet"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.0.2.0/24"]
}
