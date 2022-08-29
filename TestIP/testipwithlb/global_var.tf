# Global Variables

variable "location" {
  type    = string
  default = "northeurope"
}

variable "prefix" {
  type    = string
  default = "msa"
}

# variable "location" {
#   type = list(string)
#   default = ["northeurope", "francecentral", "germanywestcentral", "eastus"]
# }

variable "tags" {
  type = map(string)
  default = {
    "env"        = "prod"
    "cost"       = "p1"
    "provisoner" = "tf"
    "backup"     = "no"
    "project"    = "testip"
  }
}

variable "provisioner" {
  type    = string
  default = "tf"
}