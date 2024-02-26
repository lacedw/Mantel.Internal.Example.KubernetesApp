variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "sp_client_id" {
  type        = string
  description = "The client identifier for the service principal."
  default     = "cdf90cbc-ce35-46e4-997a-bb54322ea9e6"
}

variable "sp_tenant_id" {
  type        = string
  description = "The tenant identifier for the service principal."
  default     = "6b7d3a1d-4be6-417f-929f-37b0119ba799"
}

variable "sp_client_secret" {
  type        = string
  description = "The client secret for the service principal."
  sensitive   = true
}