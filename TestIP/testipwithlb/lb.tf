# Load Balancer
# resource "azurerm_resource_group" "example" {
#   name     = "LoadBalancerRG"
#   location = "West Europe"
# }

resource "azurerm_public_ip" "piplb" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
  sku_tier            = "Regional"
  tags                = var.tags
}


resource "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  sku_tier            = "Regional"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.piplb.id
  }
}

resource "azurerm_lb_backend_address_pool" "lbbp" {
  name            = "lb_bp1"
  loadbalancer_id = azurerm_lb.lb.id

}

# Only standard LB
# resource "azurerm_lb_outbound_rule" "lboutrule" {
#   name                    = "OutboundRule"
#   loadbalancer_id         = azurerm_lb.lb.id
#   protocol                = "All"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lbbp.id

#   frontend_ip_configuration {
#     name = "PublicIPAddress"
#   }
# }

resource "azurerm_lb_probe" "lbpr" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "web-running-probe"
  port                = 80
  protocol            = "Tcp" //Http or Tcp
  interval_in_seconds = 60
}

resource "azurerm_lb_probe" "lbpr2" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "web-running-probe2"
  port                = 443
  protocol            = "Tcp"
  interval_in_seconds = 60
}

resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lbbp.id]
  probe_id                       = azurerm_lb_probe.lbpr.id
  load_distribution              = "SourceIP"

  depends_on = [
    azurerm_lb_probe.lbpr
  ]
}

resource "azurerm_lb_rule" "lbrule2" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule2"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lbbp.id]
  probe_id                       = azurerm_lb_probe.lbpr2.id
  load_distribution              = "SourceIP"
  depends_on = [
    azurerm_lb_probe.lbpr2
  ]
}

# Nat Rule - enabling SSH to specific VM on selected port
resource "azurerm_lb_nat_rule" "lbnatrule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "SSHAccess"
  protocol                       = "Tcp"
  backend_port                   = 22
  frontend_port                  = 59001
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_network_interface_backend_address_pool_association" "niclb" {
  network_interface_id    = azurerm_network_interface.nic.id
  ip_configuration_name   = var.ipconfig_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbp.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic2lb" {
  network_interface_id    = azurerm_network_interface.nic2.id
  ip_configuration_name   = var.ipconfig_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbp.id
}
