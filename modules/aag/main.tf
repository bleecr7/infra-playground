# Create public IPs
resource "azurerm_public_ip" "ag_public_ip" {
  name                = "ag-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Store AG configuration in local variables
locals {
  backend_address_pool_name      = "${azurerm_subnet.ag_subnet.name}-beap"
  frontend_port_name             = "${azurerm_subnet.ag_subnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_subnet.ag_subnet.name}-feip"
  http_setting_name              = "${azurerm_subnet.ag_subnet.name}-be-htst"
  listener_name                  = "${azurerm_subnet.ag_subnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_subnet.ag_subnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_subnet.ag_subnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "web-ag"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "web-ag-ip-config"
    subnet_id = azurerm_subnet.ag_subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ag_public_ip
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

# Connect the security group to the network interface
resource "azurerm_subnet_network_security_group_association" "ag_subnet_NSG" {
  subnet_id = azurerm_subnet.ag_subnet.id
  network_security_group_id = azurerm_network_security_group.ag_nsg.id
}