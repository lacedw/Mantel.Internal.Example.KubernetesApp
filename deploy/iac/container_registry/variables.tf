variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "cluster_principal_id" {
  type = string
}