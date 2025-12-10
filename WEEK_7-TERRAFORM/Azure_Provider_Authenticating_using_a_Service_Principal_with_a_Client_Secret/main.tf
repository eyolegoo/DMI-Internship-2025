provider "azurerm" {
  features {}
  # Do NOT put subscription id.
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tf-sp-demo"
  location = "East US"
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}