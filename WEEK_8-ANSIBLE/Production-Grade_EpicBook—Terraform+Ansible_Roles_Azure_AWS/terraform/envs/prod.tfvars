location                = "australiasoutheast"
resource_group_name     = "prod-dmi-epicbook-rg"
admin_username          = "azureuser"
ssh_public_key_path     = "~/.ssh/azure_rsa.pub" # Update with your SSH public key path
vm_size                 = "B_Standard_B1ms"
db_username             = "prodepicuser"
db_password             = "Honeycomb@12345"
my_ip                   = "0.0.0.0/0" # Restrict in production as needed
tags = {
  environment = "prod"
}