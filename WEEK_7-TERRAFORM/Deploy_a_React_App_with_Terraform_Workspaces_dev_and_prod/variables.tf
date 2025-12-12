variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "West Europe"
}

variable "vm_admin_username" {
  description = "The username for the Virtual Machine's administrator account."
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "The password for the Virtual Machine's administrator account."
  type        = string
  default     = "ReactDeploy_2025!" # <<< SECURELY CHANGE THIS
  sensitive   = true
}

variable "base_name" {
  description = "Base name for resources to be combined with environment suffix."
  type        = string
  default     = "react-app"
}
