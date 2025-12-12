resource "azurerm_public_ip" "app_pip" {
  name                = "app-pip-${terraform.workspace}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = var.public_ip_sku
}

resource "azurerm_network_interface" "app_nic" {
  name                = "app-nic-${terraform.workspace}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "app_vm" {
  name                            = "epicbook-vm-${terraform.workspace}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.app_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = base64encode(
    templatefile("${path.module}/cloud-init.tpl", {
      db_host     = var.db_host
      db_username = var.db_username
      db_password = var.db_password
    })
  )

  tags = var.tags
}