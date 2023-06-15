
resource "azurerm_resource_group" "example" {
  name     = "${var.az_prefix}-resources"
  location = var.az_location
}

resource "azurerm_virtual_network" "example_primary" {
  name                = "${var.az_prefix}-virtualnetwork-primary"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = [var.az_vnet_primary_address_space, var.aks_subnet_cidr]
}

resource "azurerm_subnet" "example_primary" {
  name                 = "${var.az_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_primary.name
  address_prefixes     = [var.az_subnet_primary_address_prefix]

  delegation {
    name = "testdelegation"

    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.az_prefix}-aks-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_primary.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_netapp_account" "example_primary" {
  count = var.az_dual_protocol_bool ? 0:1
  name                = "${var.az_prefix}-netappaccount-primary"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_netapp_account" "example_primary_dual_protocol" {
  count = var.az_dual_protocol_bool ? 1:0
  name                = "${var.az_prefix}-netappaccount-primary"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  active_directory {
    username        = var.az_smb_server_username	
    password        = var.az_smb_server_password	
    smb_server_name = var.az_smb_server_name	
    dns_servers     = [var.az_smb_dns_servers]	
    domain          = "anf.local"	
  }
}

resource "azurerm_netapp_pool" "example_primary" {
  count = var.az_dual_protocol_bool ? 0:1
  name                = "${var.az_prefix}-netapppool-primary"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  account_name        = azurerm_netapp_account.example_primary[0].name
  service_level       = var.az_netapp_pool_service_level_primary
  size_in_tb          = var.az_capacity_pool_size_primary
}

resource "azurerm_netapp_pool" "example_primary_dual_protocol" {
  count = var.az_dual_protocol_bool ? 1:0
  name                = "${var.az_prefix}-netapppool-primary"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  account_name        = azurerm_netapp_account.example_primary_dual_protocol[0].name
  service_level       = var.az_netapp_pool_service_level_primary
  size_in_tb          = var.az_capacity_pool_size_primary
}
