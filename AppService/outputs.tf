output "apphostname" {
  value = azurerm_linux_web_app.lwa.default_hostname
}

output "appname" {
  value = azurerm_linux_web_app.lwa.name
}