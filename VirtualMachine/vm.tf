terraform {
  required_providers {
    azurerm = {
      #      version = "2.29.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  # subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # # client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # # client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "rg1" {
  name     = "${var.prefix}_iac_tf"
  location = var.location
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
# Create virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}_vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create public IPs
resource "azurerm_public_ip" "msapip1" {
  name                = "${var.prefix}_pip1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  domain_name_label   = var.dnsname
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}_nsg1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "95.108.30.54/32"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}_nic1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  ip_configuration {
    name                          = "${var.prefix}_nic1"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.msapip1.id
  }
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}

resource "azurerm_network_interface_security_group_association" "nicnsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg1.name
  }
  byte_length = 8
}
# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
# Create virtual machine
resource "azurerm_virtual_machine" "Ubuntu" {
  name                  = "Ubuntu"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  # network_interface_ids = ["${azurerm_network_interface.nic.*.id}"]
  vm_size               = var.vmsize
  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }
  os_profile {
    computer_name  = "Ubuntu"
    admin_username = "ncadmin"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/ncadmin/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvimFW5zoaSKnDrXzKUXB7bB/8\r\n410E4lR1wihgE3fLCGXwMDu8QxiGjIVWguptEBefI6urGikbXGLHCVvIFHFPai/5\r\nj3ekzLKMDYIHUC504fl1Gf4c+t9Petc4XvKjqELXfuQ3Jy2huaMr0o1CoKmckBLQ\r\neoqlTMjBFvHxeO5dR3OBLnvyRFsV5qrD4x8T0dmyE2NbBzqCcTSg3FnEIg28ZlX+\r\nVjkHyY90xq0vu/C/80YaC0RSryF2/i5r1faTOQQuILKtVlFpsAxqsIfDGN+A6IfQ\r\n6kqVqZicPTLan2saDIqph3g8iRPs3erell/xaUpvZjPYRTlpL0XNfR9hgVZT7Gvx\r\nQzAN/GotzvAzwp5OqoPCOTGHYHpg9bVSJW6XBXBg54j6Aowrxg3dVhv2n9mhwGJv\r\nnoBNLEKhyvRqi0N0Dgmb+kC0p6KJjj2D7nDcxO2dDqp40YFkMCIBl/MntJ6tnr4q\r\nGfZOpnqVEiYQYUpmRuzpPDlsuMOFJnp3pTLWPF0= generated-by-azure\r\n"
    }
  }
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
