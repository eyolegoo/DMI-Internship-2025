terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "eefd5776-f8cb-44a7-8096-a47d743b8959"
}
