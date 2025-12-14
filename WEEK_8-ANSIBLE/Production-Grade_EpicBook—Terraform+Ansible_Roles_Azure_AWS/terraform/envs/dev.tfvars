location                = "australiaeast"
resource_group_name     = "dmi-epicbook-rg"
admin_username          = "azureuser"
ssh_public_key_path     = "~/.ssh/azure_rsa.pub" # Update with your SSH public key path
vm_size                 = "B_Standard_B1ms"
db_username             = "devepicuser"
db_password             = "Youandme@12345"
my_ip                   = "0.0.0.0/0"
tags = {
  environment = "dev"
}