# Variables
variable "location" {
  default = "eastus"
}

variable "prefix" {
  default = "msafs-tf1"
}
variable "storage_prefix" {
  default = "msafstf1"
}

variable "satier" {
  default = "Standard"
}

variable "satype" {
  default = ["LRS", "ZRS", "GRS"]
  type    = list(any)
}

## clientaccessip - type here IP of the host from which you are provisioning storage account 
variable "clientaccessip" {
}