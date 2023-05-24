resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = var.nodeCount
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  tags = {
    environment = var.environmentName
  }
}

resource "null_resource" "trident-installer" {
 depends_on = [ azurerm_kubernetes_cluster.default ]
 provisioner "local-exec" {
    command = "/bin/bash ./trident-installation-script.sh"

    environment = {
      resource_group_name       = azurerm_resource_group.example.name
      kubernetes_cluster_name   = azurerm_kubernetes_cluster.default.name
      azure_subscription_id = var.azure_subscription_id,
      azure_sp_tenant_id = var.azure_sp_tenant_id,
      azure_sp_client_id = var.appId,
      azure_sp_secret = var.password,
      trident_location = var.trident_location
      az_netapp_pool_service_level_primary = var.az_netapp_pool_service_level_primary
     }
  }
}
