# Load Balancer
# resource "azurerm_resource_group" "example" {
#   name     = "LoadBalancerRG"
#   location = "West Europe"
# }

# resource "azurerm_public_ip" "example" {
#   name                = "PublicIPForLB"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   allocation_method   = "Static"
# }

resource "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  sku_tier            = "Regional"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip[0].id
  }
}

resource "azurerm_lb_backend_address_pool" "lbbp" {
  name            = "lb_bp1"
  loadbalancer_id = azurerm_lb.lb.id

}

resource "azurerm_lb_outbound_rule" "lboutrule" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.lb.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbp.id

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}

resource "azurerm_lb_probe" "lbpr" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "web-running-probe"
  port            = 80
  protocol        = "Tcp"
}


resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lbbp.id]
  probe_id                       = azurerm_lb_probe.lbpr.id
}