output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "kubernetes_cluster_name" {
  value = module.cluster.cluster_name
}

output "client_certificate" {
  value     = module.cluster.client_certificate
  sensitive = true
}

output "client_key" {
  value     = module.cluster.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = module.cluster.cluster_ca_certificate
  sensitive = true
}

output "cluster_password" {
  value     = module.cluster.cluster_password
  sensitive = true
}

output "cluster_username" {
  value     = module.cluster.cluster_username
  sensitive = true
}

output "host" {
  value     = module.cluster.cluster_host
  sensitive = true
}

output "kube_config" {
  value     = module.cluster.kube_config
  sensitive = true
}