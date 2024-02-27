# Generate a name for the Resource Group.
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

# Create the Resource Group.
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

module "ssh" {
  source = "./ssh"
  rg_id  = azurerm_resource_group.rg.id
  rg_location = azurerm_resource_group.rg.location
}

# Create the AKS Cluster.
module "cluster" {
  source = "./cluster"
  rg_name = azurerm_resource_group.rg.name
  rg_location = azurerm_resource_group.rg.location
  public_key = module.ssh.key_data
}

# Create the ACR & Assign Role to AKS Cluster.
module "container_registry" {
  source = "./container_registry"
  cluster_user_assigned_identity_principal_id = module.cluster.user_assigned_identity_principal_id
  cluster_system_assigned_identity_principal_id = module.cluster.system_assigned_identity_principal_id
  kubelet_identity_object_id = module.cluster.kubelet_identity_object_id
  rg_name = azurerm_resource_group.rg.name
  rg_location = azurerm_resource_group.rg.location
}

locals {
  repository_name = "weather-forecast"
  image_tag = "0.1.11"
}

resource "null_resource" "docker_build" {
  depends_on = [module.container_registry]
  triggers = {
    image_tag = local.image_tag
    repository_name = local.repository_name
  }
  provisioner "local-exec" {
    command = <<-EOT
      az login --service-principal -u ${var.sp_client_id} -p ${var.sp_client_secret} --tenant ${var.sp_tenant_id}
      TOKEN=$(az acr login --name ${module.container_registry.registry_name} --expose-token --output tsv --query accessToken)
      docker login ${module.container_registry.registry_name}.azurecr.io --username 00000000-0000-0000-0000-000000000000 --password-stdin <<< $TOKEN
      docker build -t ${module.container_registry.registry_name}.azurecr.io/${local.repository_name}:${local.image_tag} -f ../../Mantel.Internal.Example.KubernetesApp/Dockerfile --no-cache --platform linux/amd64 ../../
      docker push ${module.container_registry.registry_name}.azurecr.io/${local.repository_name}:${local.image_tag}
    EOT
  }
}

# Install the Application on the Kubernetes Cluster via HELM.
resource "helm_release" "weather_forecast" {
  name       = "main"
  repository = "../charts"
  chart      = "main"
  depends_on = [null_resource.docker_build]
  set {
    name = "image.repository"
    value = "${module.container_registry.registry_name}.azurecr.io/${local.repository_name}"
  }
  set {
    name = "image.tag"
    value = local.image_tag
  }
  set {
    name = "service.port"
    value = 80
  }
}