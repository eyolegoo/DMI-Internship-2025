output "app_public_ip" {
  value = azurerm_public_ip.app_pip.ip_address
}