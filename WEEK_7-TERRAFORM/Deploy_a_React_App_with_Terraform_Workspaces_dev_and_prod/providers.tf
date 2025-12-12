# Define the Azure Provider
provider "azurerm" {
  features {}
}

# Remote Backend Configuration
# These values MUST match the resources created by backend_setup.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatewilliams123g"
    container_name       = "tfstate"
    # key is set by CLI command during workspace setup
  }
}
