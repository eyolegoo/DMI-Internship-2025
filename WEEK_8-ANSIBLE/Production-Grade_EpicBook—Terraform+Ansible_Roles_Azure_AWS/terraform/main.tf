resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  my_ip               = var.my_ip
  depends_on          = [azurerm_resource_group.rg]
  tags = merge(var.tags, { project="epicbook", environment=terraform.workspace })
}

module "database" {
  source              = "./modules/database"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.mysql_subnet_id
  db_username         = var.db_username
  db_password         = var.db_password
  depends_on          = [azurerm_resource_group.rg]
  tags = merge(var.tags, { project="epicbook", environment=terraform.workspace })
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
  subnet_id           = module.network.public_subnet_id
  db_host             = module.database.db_host
  db_username         = var.db_username
  db_password         = var.db_password
  public_ip_sku       = var.public_ip_sku
  depends_on          = [azurerm_resource_group.rg]
  tags = merge(var.tags, { project="epicbook", environment=terraform.workspace })
}