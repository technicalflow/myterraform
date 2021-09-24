output "PIP" {
  value = azurerm_public_ip.msapip1.ip_address
}

output "VM_private_IP" {
  value = azurerm_network_interface.nic.private_ip_address
}
output "DNS" {
  value = azurerm_public_ip.msapip1.domain_name_label
}

output "FQDN" {
  value = azurerm_public_ip.msapip1.fqdn
}