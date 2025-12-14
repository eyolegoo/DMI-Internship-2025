variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "Assignment34-RG"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Australia Central"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/azure_rsa.pub"
}
