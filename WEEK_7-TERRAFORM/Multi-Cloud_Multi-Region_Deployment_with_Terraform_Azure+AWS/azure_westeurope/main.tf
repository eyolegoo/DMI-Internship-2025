provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-dev-assets-westeurope"
  location = "West Europe"
  tags = {
    project = "multicloud-foundation"
    owner   = "williams"
    env     = "dev"
  }
}

resource "azurerm_storage_account" "assets" {
  name                     = "devassetswilliamswe"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    project = "multicloud-foundation"
    owner   = "williams"
    env     = "dev"
  }
}

# --- Outputs ---
output "azure_westeurope_storage_account_name" {
  value = azurerm_storage_account.assets.name
}

output "azure_westeurope_primary_endpoint" {
  value = azurerm_storage_account.assets.primary_blob_endpoint
}