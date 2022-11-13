# Create public IPs
resource "azurerm_public_ip" "msapip1" {
  name                = "${var.prefix}_pip1"
  location            = azurerm_resource_group.rg300.location
  resource_group_name = azurerm_resource_group.rg300.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  sku_tier            = "Regional"
  domain_name_label   = var.dnsname
  ip_version          = "IPv4"

  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}
# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}_nsg1"
  location            = azurerm_resource_group.rg300.location
  resource_group_name = azurerm_resource_group.rg300.name
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  security_rule {
    name                       = "WEB"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  #
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}


data "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg300.name
  virtual_network_name = azurerm_virtual_network.vnet[2].name
  depends_on = [
    azurerm_virtual_network.vnet[0]
  ]
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}_nic1"
  location            = azurerm_resource_group.rg300.location
  resource_group_name = azurerm_resource_group.rg300.name
  ip_configuration {
    name      = "${var.prefix}_nic1"
    subnet_id = data.azurerm_subnet.subnet1.id
    # subnet_id                     = azurerm_virtual_network.vnet[0].subnet[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.msapip1.id
  }
  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
  depends_on = [
    azurerm_network_security_group.nsg,
    data.azurerm_subnet.subnet1
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

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg300.name
  }
  byte_length = 4
}

resource "random_password" "password" {
  length  = 16
  numeric = true
  special = true
  upper   = true
  lower   = true
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm2" {
  name                            = "${var.prefix}_ubuntu"
  location                        = azurerm_resource_group.rg300.location
  resource_group_name             = azurerm_resource_group.rg300.name
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = var.vmsize
  admin_username                  = "vmadmin"
  admin_password                  = random_password.password.result
  computer_name                   = "ubuntu"
  disable_password_authentication = false
  admin_ssh_key {
    public_key = file("~/.ssh/ansible.pub")
    username = "vmadmin"
  }

  os_disk {
    name                 = "ubuntuOsDisk${random_id.randomId.hex}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal-daily"
    sku       = "20_04-daily-lts"
    version   = "latest"
  }

  tags = {
    environment = "Dev/Test"
    provisioner = "Terraform"
  }
}

# "sudo apt update && sudo apt upgrade -y",
# "sudo apt install nginx -y && sudo systemctl enable --now nginx"

output "publicip" {
  value = azurerm_linux_virtual_machine.vm2.public_ip_address
}
output "dns" {
  value = azurerm_public_ip.msapip1.fqdn
}