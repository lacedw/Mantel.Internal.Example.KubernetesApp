resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_user_assigned_identity" "azurerm_kubernetes_cluster_user_assigned_identity" {
  name                = "identity-${random_pet.azurerm_kubernetes_cluster_name.id}"
  resource_group_name = var.rg_name
  location            = var.rg_location
}

resource "azurerm_kubernetes_cluster" "aks" {
  location            = var.rg_location
  name                = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name = var.rg_name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  http_application_routing_enabled = true

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.azurerm_kubernetes_cluster_user_assigned_identity.id]
  }
  
  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }
  
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = var.public_key
    }
  }
  
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}