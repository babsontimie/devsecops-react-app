provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "githubActions-RG"
  location = "UK South"
}

# AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "githubActions-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "ghactions-cluster"

  default_node_pool {
    name       = "agentpool"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.32.6"
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

# Output kubeconfig
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
