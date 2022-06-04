provider "azurerm" {
  #version = "=1.36.0"
  features {

  }
}

resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg"
  location = var.location
}

resource "azurerm_service_plan" "defaultsp" {
  name                = "${var.name}-plan"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "lwa" {
  name                = "${var.dns_prefix}-${var.name}-${var.environment}-app"
  location            = azurerm_service_plan.defaultsp.location
  resource_group_name = azurerm_resource_group.default.name
  service_plan_id     = azurerm_service_plan.defaultsp.id
  site_config {
    always_on = true
    application_stack {
      docker_image     = "nginxdemos/hello"
      docker_image_tag = "latest"
    }
  }
  identity {
    type = "SystemAssigned"
  }
  #   site_config {
  #     always_on        = true
  #     java_version           = "1.8"
  #     java_container         = "tomcat"
  #     java_container_version = "9.0"
  #   }
}