resource "azurerm_mysql_flexible_server" "myepicbooksql" {
  name                = "epicbook-mysql-${terraform.workspace}"
  resource_group_name = var.resource_group_name
  location            = var.location
  administrator_login = var.db_username
  administrator_password = var.db_password
  sku_name            = "B_Standard_B1ms"
  version             = "8.0.21"
  delegated_subnet_id = var.subnet_id
  tags                = var.tags
}

resource "azurerm_mysql_flexible_database" "epicbook_db" {
  name                = "epicbook"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.myepicbooksql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}