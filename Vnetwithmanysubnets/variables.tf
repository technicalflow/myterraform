# VARIABLES                                      #

variable "common_tags" {
  type = map(string)
  default = {
    Terraform   = "True"
    Description = "Terraform"
  }
  description = "Optional Input - A map of key value pairs that is used to tag resources created. (Default: demo map)"
}

variable "create_rg" {
  type        = bool
  default     = true
  description = "Optional Input - Create a new resource group for this deployment. (Set to false to use existing resource group)"
}

variable "create_vnet" {
  type        = bool
  default     = true
  description = "Optional Input - Create a new Azure Virtual Network for this deployment. (Set to false to use existing Azure Virtual Network)"
}

variable "dns_entries" {
  type        = list(string)
  default     = []
  description = "Optional Input - Set custom dns config. If no values specified, this defaults to Azure DNS (Only in effect on newly created Vnet when variable:create_vnet=true)"
}

variable "environment" {
  type        = string
  default     = "Development"
  description = "Optional Input - Value to describe the environment. Used for tagging. (Default: Development)"
}

variable "location" {
  type        = string
  default     = "francecentral"
  description = "Optional Input - Location in azure where resources will be created. (Only in effect on newly created Resource Group when variable:create_rg=true)"
}

variable "network_address_ip" {
  type        = string
  default     = "10.1.0.0"
  description = "Optional Input - Network IP to construct network address space. (Only in effect on newly created Vnet when variable:create_vnet=true)"
}

variable "network_address_mask" {
  type        = number
  default     = 16
  description = "Optional Input - Network address mask to construct network address space. (Only in effect on newly created Vnet when variable:create_vnet=true)"
}

variable "virtual_network_rg_name" {
  type        = string
  default     = "rg1"
  description = "Optional Input - Name of the resource group the existing Vnet is in. (create_rg=false) / Name of the resource group the Vnet will be created in. (create_rg=true)."
}

variable "virtual_network_name" {
  type        = string
  default     = "vnet1"
  description = "Optional Input - Name of the existing Vnet subnets will be created in. (create_vnet=false) / Name of the new Vnet that will be created. (create_vnet=true)"
}

variable "subnet_config" {
  type = map(any)
  default = {
    Prod = {
      name      = "prod"
      mask      = 25
      cidr_base = "10.1.0.0"
    }
    Dev = {
      name      = "dev"
      mask      = 26
      cidr_base = "10.1.0.128"
    }
    Dmz = {
      name      = "DMZ"
      mask      = 27
      cidr_base = "10.1.0.192"
    }
    FW = {
      name      = "FW"
      mask      = 29
      cidr_base = "10.1.0.248"
    }
  }
  description = "Optional Input - Subnet config map for each subnet to be created in either existing or newly created VNET based on. (create_vnet=true/false)"
}