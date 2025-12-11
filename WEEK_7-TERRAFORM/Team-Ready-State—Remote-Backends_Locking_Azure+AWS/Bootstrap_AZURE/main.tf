terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group to hold the backend infra
resource "azurerm_resource_group" "backend" {
  name     = "rg-tfstate-backend"
  location = "East US"
}

# Storage Account for Terraform state
resource "azurerm_storage_account" "backend" {
  name                     = "tfstatewilliamsprod" # must be globally unique
  resource_group_name      = azurerm_resource_group.backend.name
  location                 = azurerm_resource_group.backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Blob Container for state files
resource "azurerm_storage_container" "backend" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.backend.id  # ✅ modern attribute
  container_access_type = "private"
}