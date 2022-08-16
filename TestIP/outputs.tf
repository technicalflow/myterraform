output "pip" {
  value = azurerm_public_ip.pip[*].ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "vm_username" {
  value = azurerm_linux_virtual_machine.vm.admin_username
}