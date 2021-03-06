terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
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
  name     = "${var.prefix}_rg1"
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
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet"
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
  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_subnet.mysubnet
  ]
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

resource "azurerm_network_security_rule" "allow_web" {
  name                        = "Web"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}_nic1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  ip_configuration {
    name                          = "${var.prefix}_nic1"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.msapip1.id
  }
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_virtual_network.vnet1
  ]
}

resource "azurerm_network_interface_security_group_association" "nicnsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_network_interface.nic,
    azurerm_network_security_group.nsg
  ]
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg1.name
  }
  byte_length = 4
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
resource "azurerm_virtual_machine" "ubuntuvm" {
  name                  = "${var.prefix}_ubuntu"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  # network_interface_ids = ["${azurerm_network_interface.nic.*.id}"]
  vm_size = var.vmsize
  storage_os_disk {
    name              = "ubuntuOsDisk${random_id.randomId.hex}"
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
    computer_name  = "ubuntu"
    admin_username = "ncadmin"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/ncadmin/.ssh/authorized_keys"
      key_data = file("./sshkey.pub")
    }
  }
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt upgrade -y",
      "sudo apt install nginx -y && sudo service nginx start"
    ]
    connection {
      type        = "ssh"
      user        = "ncadmin"
      port        = 22
      private_key = file("./sshkey")
      #private_key = var.sshkey
      host        = azurerm_public_ip.msapip1.fqdn
    }
  }

  depends_on = [
    azurerm_network_interface.nic,
    azurerm_network_security_group.nsg,
    azurerm_public_ip.msapip1,
    azurerm_resource_group.rg1,
    azurerm_storage_account.mystorageaccount,
    azurerm_subnet.mysubnet,
    azurerm_virtual_network.vnet1,
    azurerm_network_security_group.nsg
  ]
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
data "azurerm_public_ip" "msapip1read" {
  name                = azurerm_public_ip.msapip1.name
  resource_group_name = azurerm_resource_group.rg1.name
}