# Variables
variable "admin_username" {
  type    = string
  default = "azuremadmin"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
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

variable "ssh_ip" {
  type    = string
  default = "46.187.244.193"
}

variable "subnet_name" {
  type    = string
  default = "subnet1"
}