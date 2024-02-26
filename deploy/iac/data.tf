data "azurerm_kubernetes_cluster" "aks" {
  depends_on          = [module.cluster]
  name                = module.cluster.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
}