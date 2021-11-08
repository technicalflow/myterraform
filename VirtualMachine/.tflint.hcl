plugin "azurerm" {
  enabled = true
  version = "0.13.1"
  source = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_naming_convention" {
enabled = false
}

rule "terraform_documented_variables" {
enabled = false
}

rule "azurerm_linux_virtual_machine_invalid_size" {
enabled = true
}

rule "azurerm_linux_virtual_machine_scale_set_invalid_sku" {
enabled = true
}
rule "azurerm_virtual_machine_invalid_vm_size" {
enabled = true
}

rule "azurerm_windows_virtual_machine_invalid_size" {
enabled = true
}
rule "azurerm_windows_virtual_machine_scale_set_invalid_sku" {
enabled = true
}
