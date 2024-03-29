resource "random_pet" "azurerm_container_registry_name" {
  prefix = "cr"
}

resource "azurerm_container_registry" "acr" {
  name                = replace(random_pet.azurerm_container_registry_name.id, "-", "")
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Basic"
}

/*
resource "azurerm_role_assignment" "aks_acr_system_assigned_identity_role_assignment" {
  principal_id                     = var.cluster_system_assigned_identity_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
*/

resource "azurerm_role_assignment" "aks_acr_user_assigned_identity_role_assignment" {
  principal_id                     = var.cluster_user_assigned_identity_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_acr_kubelet_identity_role_assignment" {
  principal_id                     = var.kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}