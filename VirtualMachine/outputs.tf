output "PIP" {
  value = azurerm_public_ip.msapip1.ip_address
}
output "DNS" {
  value = azurerm_public_ip.msapip1.domain_name_label
}