output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vm_public_ips" {
  value = {
    for idx, ip in azurerm_public_ip.main : 
    "vm-${idx + 1}" => ip.ip_address
  }
}

output "vm_names" {
  value = [for vm in azurerm_linux_virtual_machine.main : vm.name]
}
