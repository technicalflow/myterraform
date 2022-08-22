provider "ovh" {
  endpoint           = var.dns_ovh_endpoint
  application_key    = var.dns_ovh_application_key
  application_secret = var.dns_ovh_application_secret
  consumer_key       = var.dns_ovh_consumer_key
}

data "ovh_me" "ovh" {}

data "azurerm_public_ip" "pipread" {
  name                = azurerm_public_ip.pip[0].name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "ovh_domain_zone_record" "testip" {
  zone      = var.domain_name
  subdomain = null
  fieldtype = "A"
  ttl       = "0"
  target    = data.azurerm_public_ip.pipread.ip_address

  depends_on = [
    azurerm_public_ip.pip
  ]
}