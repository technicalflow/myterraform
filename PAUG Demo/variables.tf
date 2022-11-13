# Variables
variable "location" {
  default = "francecentral"
  # validation {
  #   condition = regex("[a-z]", var.location)
  #   error_message = "Please provide required location name."
  # }
}

variable "prefix" {
  default = "PAUG_DEMO"
}

variable "vmsize" {
  default = "Standard_B1ls"
  validation {
    condition = anytrue([
      var.vmsize == "Standard_DS2",
      var.vmsize == "Standard_D2",
      var.vmsize == "Standard_B1ls"
    ])
    error_message = "Choose proper VM size."
  }
}

variable "dnsname" {
  default = "msafs-tf-ubuntu"
}

# variable "sshkey" {
#   type = string
# }

variable "environment" {
  type        = string
  description = <<EOT
  (Optional) The environment short name to use for the deployed resources.

  Options:
  - dev
  - uat
  - prd

  Default: dev
  EOT
  default     = "dev"

  validation {
    condition     = can(regex("^dev$|^uat$|^prd$", var.environment))
    error_message = "Err: invalid environment."
  }

  validation {
    condition     = length(var.environment) <= 3
    error_message = "Err: environment is too long."
  }
}