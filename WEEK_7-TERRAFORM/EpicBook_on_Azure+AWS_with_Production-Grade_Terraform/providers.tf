terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "epicbook-rg"
    storage_account_name = "tfstateepicbooklego"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = "eefd5776-f8cb-44a7-8096-a47d743b8959"
}
