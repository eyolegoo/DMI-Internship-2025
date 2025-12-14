variable "admin_username" {
default = "Godwin"
}

variable "location" {
default = "Australia Central"
}

variable "vm_name" {
default = "mini-finance-vm"
}

variable "resource_group_name" {
default = "mini-finance-rg"
}

variable "ssh_public_key_path" {
description = "Path to your SSH Public Key"
default	= "~/.ssh/azure_rsa.pub"
}
