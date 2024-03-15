resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}vnet"
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = [var.virtual_network_address_prefix]
}
resource "azurerm_subnet" "public_sub" {
  name                 = "${var.prefix}PublicSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_prefix]
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.ContainerRegistry",
    "Microsoft.AzureActiveDirectory",
    "Microsoft.Storage",
    "Microsoft.AzureActiveDirectory",
    "Microsoft.EventHub",
    "Microsoft.ServiceBus"
  ]
}
resource "azurerm_subnet" "private_sub" {
  name                 = "${var.prefix}PrivateSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_prefix]
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.ContainerRegistry",
    "Microsoft.AzureActiveDirectory",
    "Microsoft.Storage",
    "Microsoft.AzureActiveDirectory",
    "Microsoft.EventHub",
    "Microsoft.ServiceBus"
  ]
}

resource "azurerm_subnet" "private_sub_psql" {
  name                 = "${var.prefix}PrivateSubnetPsql"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.psql_private_subnet_prefix]
  service_endpoints = [
    "Microsoft.Storage",
  ]
  delegation {
    name = "psql_fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = "${var.prefix}AppGatewayPublicIP"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.prefix}-test"
}

###
# Security Groups, Routes

# resource "azurerm_network_security_group" "public_sg" {
#   name                = "public-nsg"
#   location            = var.location
#   resource_group_name = var.rg_name
# }

resource "azurerm_network_security_group" "private_sg" {
  name                = "${var.prefix}-private-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  security_rule {
    name                       = "HTTPInb"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPOutb"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPSInb"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPSOutb"
    priority                   = 111
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.private_sub.id
  network_security_group_id = azurerm_network_security_group.private_sg.id
}