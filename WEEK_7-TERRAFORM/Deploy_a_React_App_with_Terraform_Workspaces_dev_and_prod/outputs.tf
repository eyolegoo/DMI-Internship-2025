output "current_workspace" {
  description = "The current active Terraform workspace."
  value       = terraform.workspace
}

output "public_ip_address" {
  description = "The Public IP Address of the current environment's VM."
  value       = azurerm_public_ip.pip.ip_address
}

output "web_url" {
  description = "The HTTP web URL for the current environment."
  value       = "http://${azurerm_public_ip.pip.ip_address}"
}

output "resource_group_name" {
  description = "The name of the Resource Group created."
  value       = azurerm_resource_group.rg.name
}
