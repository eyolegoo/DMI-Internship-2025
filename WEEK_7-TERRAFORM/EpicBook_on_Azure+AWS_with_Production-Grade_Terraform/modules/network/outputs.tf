output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "mysql_subnet_id" {
  value = azurerm_subnet.mysql.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.mysql_dns.id
}