terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    # Values supplied at init
    # storage_account_name = "tfstatewilliamsprod"
    # container_name       = "tfstate"
    # key                  = "envs/prod/terraform.tfstate"
    # use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-remote-state-demo_1"
  location = "East US"
}

output "resource_group_name" {
  value = azurerm_resource_group.demo.name
}