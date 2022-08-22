#OVH variables
variable "domain_name" {
  type = string
  # default = "testip.fun"
}

variable "dns_ovh_endpoint" {
  type = string
}

variable "dns_ovh_application_key" {
  type = string
}

variable "dns_ovh_application_secret" {
  type = string
}

variable "dns_ovh_consumer_key" {
  type = string
}