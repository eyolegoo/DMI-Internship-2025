# --- 1. Resource Group ---
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# --- 2. Virtual Network and Subnet ---
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}

resource "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# --- 3. Network Security Group (NSG) to allow 22, 80, 443 ---
resource "azurerm_network_security_group" "nsg" {
  name                = local.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

  # Dynamic block for required ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)
  dynamic "security_rule" {
    for_each = {
      ssh   = 22
      http  = 80
      https = 443
    }
    content {
      name                       = "Allow-${security_rule.key}"
      priority                   = 100 + security_rule.value
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }
}

# Associate NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# --- 4. Public IP Address ---
resource "azurerm_public_ip" "pip" {
  name                = local.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = local.common_tags
}

# --- 5. Network Interface (NIC) ---
resource "azurerm_network_interface" "nic" {
  name                = local.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# --- 6. Ubuntu 24.04 Virtual Machine ---
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = local.vm_name
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = local.env.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic.id]
  tags                            = local.common_tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy" # Ubuntu 24.04 LTS
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Executes the user_data.sh script on first boot
  custom_data = base64encode(file("user_data.sh"))
}
