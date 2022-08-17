# Variables
variable "image_name" {
  type        = string
  description = "Choose your system - ubuntu or oracle"
  default     = "ubuntu"
}

variable "admin_username" {
  type    = string
  default = "azuremadmin"
}

variable "vm_size" {
  type    = list(any)
  default = ["Standard_B1s", "Standard_B1ls"]
}

variable "disable_password_authentication" {
  type    = bool
  default = true
}

variable "admin_password" {
  type    = string
  default = null
}

variable "enable_public_ip_address" {
  type    = bool
  default = true
}

variable "number_of_nics" {
  type    = number
  default = 1
}

variable "ipconfig_name" {
  type    = string
  default = "ipconfig1"
}

variable "ssh_ip" {
  type    = string
  default = "46.187.244.193"
}

variable "subnet_name" {
  type    = string
  default = "subnet1"
}

variable "image_list" {
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    oracle = {
      publisher = "oracle"
      offer     = "oracle-linux"
      sku       = "ol86-lvm"
      version   = "latest"
    },
    ubuntu = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },
  }
}

variable "redundancy" {
  type    = list(any)
  default = ["LRS", "ZRS", "GRS"]
}

variable "disk_type" {
  type = map(string)
  default = {
    Standard_HDD = "Standard"
    Premium_SSD  = "Premium"
    Standard_SSD = "StandardSSD"
  }
}

variable "disk_caching" {
  type    = string
  default = "ReadWrite"
}

# variable "security_rules" {
#   type = map(object({
#     name     = string
#     priority = number
#     protocol = string
#     port     = number
#   }))

#   default = {
#     web = {
#       name     = "Web"
#       priority = 1002
#       protocol = "Tcp"
#       port     = 80
#     }
#   }
# }