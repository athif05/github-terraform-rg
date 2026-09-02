// ============================================================
// Resource Group
// ============================================================

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    deployed_by = "github-actions"
  }
}


// ============================================================
// VNet
// Depends on: Resource Group
// ============================================================

resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.vnet_address_space

  depends_on = [
    azurerm_resource_group.example
  ]

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}


// ============================================================
// Subnet
// Depends on: VNet
// ============================================================

resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet_address_prefixes

  depends_on = [
    azurerm_virtual_network.example
  ]
}


// ============================================================
// Public IP
// Depends on: Resource Group
// ============================================================

resource "azurerm_public_ip" "example" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  allocation_method = "Static"
  sku               = "Standard"

  depends_on = [
    azurerm_resource_group.example
  ]

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}


// ============================================================
// Network Security Group
// Depends on: Resource Group
// ============================================================

resource "azurerm_network_security_group" "example" {
  name                = var.nsg_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_resource_group.example
  ]

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}


// ============================================================
// Network Interface
// Depends on:
//   - Subnet
//   - Public IP
//   - Resource Group
// ============================================================

resource "azurerm_network_interface" "example" {
  name                = var.nic_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }

  depends_on = [
    azurerm_subnet.example,
    azurerm_public_ip.example
  ]

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}


// ============================================================
// NSG -> NIC Association
// Depends on:
//   - NIC
//   - NSG
// ============================================================

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id

  depends_on = [
    azurerm_network_interface.example,
    azurerm_network_security_group.example
  ]
}


// ============================================================
// Linux Virtual Machine
// Depends on:
//   - NIC
//   - NSG Association
// ============================================================

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  depends_on = [
    azurerm_network_interface_security_group_association.example
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    deployed_by = "github-actions"
  }
}