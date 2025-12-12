output "app_public_ip" {
  value       = module.compute.app_public_ip
  description = "Public IP of the app VM"
}

output "db_host" {
  value       = module.database.db_host
  description = "Private FQDN of MySQL Flexible Server"
}