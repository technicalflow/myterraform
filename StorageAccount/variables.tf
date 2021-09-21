# Variables
variable "location" {
  default = "france_central"
}

variable "prefix" {
  default = "msa"
}

variable "satier" {
  default = "Standard"
}

variable "satype" {
  default = ["LRS", "ZRS", "GRS"]
  type    = list(any)
}