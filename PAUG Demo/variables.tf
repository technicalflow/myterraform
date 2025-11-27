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
