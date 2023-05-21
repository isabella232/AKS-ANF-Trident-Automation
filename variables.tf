variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

variable "environmentName" {
  description = "Environment Name used for AKS"
}

variable "location" {
  description = "Region where AKS is deployed"
}

variable "nodeCount" {
  description = "Number of nodes needed as part of the AKS cluster"
}



# ANF vars


variable "az_location" {
  description = "Azure Region"
}

variable "az_prefix" {
  description = "The prefix used for all resources used by this NetApp Volume"
}

variable "az_vnet_primary_address_space" {
    description = "The address space used by the primary virtual network"
}

variable "az_vnet_secondary_address_space" {
    description = "The address space used by the secondary virtual network"
}

variable "az_subnet_primary_address_prefix" {
    description = "The address prefix used to create the primary subnet"
}

variable "az_subnet_secondary_address_prefix" {
    description = "The address prefix used to create the secondary subnet"
}

variable "az_volume_path_primary" {
  description = "path used to create primary volume"
}

variable "az_volume_path_secondary" {
  description = "path used to create secondary volume"
}

variable "az_capacity_pool_size_primary" {
  description = "Enter the size in Tb for the primary netapp capacity pool"
}

variable "az_capacity_pool_size_secondary" {
  description = "Enter the size in Tb for the secondary netapp capacity pool"
}

variable "az_vnet_primary_creation_bool" {
  description = "Do you want to create a new primary vnet?"
  type = bool
}

variable "az_vnet_secondary_creation_bool" {
  description = "Do you want to create a new secondary vnet?"
  type = bool
}

variable "az_subnet_primary_creation_bool" {
  description = "Do you want to create a new primary Subnet?"
  type = bool
}

variable "az_subnet_secondary_creation_bool" {
  description = "Do you want to create a new secondary Subnet?"
  type = bool
}

variable "az_primary_subnet_id_for_anf_vol" {
  description = "Enter the primary Subnet ID needed for creating ANF volume"
}

variable "az_secondary_subnet_id_for_anf_vol" {
  description = "Enter the secondary Subnet ID needed for creating ANF volume"
}

variable "az_netapp_pool_service_level_primary" {
  description = "Enter the primary service level for creating the netapp pool"
}

variable "az_netapp_pool_service_level_secondary" {
  description = "Enter the secondary service level for creating the netapp pool"
}

variable "az_netapp_vol_service_level_primary" {
  description = "Enter the primary service level to be used to create the new netapp ANF volume"
}

variable "az_netapp_vol_service_level_secondary" {
  description = "Enter the secondary service level to be used to create the new netapp ANF volume"
}

# variable "az_netapp_vol_protocol_primary" {
#   description = "Enter the primary protocol to be used for the new netapp volume"
# }

# variable "az_netapp_vol_protocol_secondary" {
#   description = "Enter the secondary protocol to be used for the new netapp volume"
# }


variable "az_netapp_vol_storage_quota_primary" {
  description = "Enter the primary Storage quota in GB for the new netapp volume"
}

variable "az_netapp_vol_storage_quota_secondary" {
  description = "Enter the secondary Storage quota in GB for the new netapp volume"
}

variable "az_dp_replication_frequency" {
  description = "Enter the frequency of CRR required. Replication frequency, supported values are '10minutes', 'hourly', 'daily', values are case sensitive."
}

variable "az_alt_location" {
  description = "The Azure location where the secondary volume will be created. Ensure to make use of Azure supported regional pairs (https://learn.microsoft.com/en-gb/azure/azure-netapp-files/cross-region-replication-introduction#supported-region-pairs)"
}


# ANF Dual protocol vars

variable "az_dual_protocol_bool" {
  description = "True to enable NFS and SMB, False to restrict to a single protocol"
}

variable "az_smb_server_username" {
  description = "Username to create ActiveDirectory object"
}

variable "az_smb_server_password" {
  description = "User password to create ActiveDirectory object"
}

variable "az_smb_server_name" {
  description = "Server Name to create ActiveDirectory object."
}

variable "az_smb_dns_servers" {
  description = "DNS Server IP to create ActiveDirectory object."
}


variable "az_netapp_vol_protocol1" {
  description = "Enter the first protocol to be used for the new netapp volume"
}

variable "az_netapp_vol_protocol2" {
  description = "Enter the second protocol to be used for the new netapp volume"
}


#Azure vars

variable "azure_subscription_id" {
  description = "Azure Account Subscription ID"
}

variable "azure_sp_tenant_id" {
  description = "Tenant ID of Azure Service Principal"
}

variable "azure_sp_client_id" {
  description = "Client ID of Azure Service Principal"
}

variable "azure_sp_secret" {
  description = "Secret Value of Azure Service Principal"
}

variable "trident_location" {
  description = "Region where Trident storage backend is being configured"
}

variable "aks_subnet_cidr" {
  description = "Enter the CIDR range (/16 subnet) for the Subnet to be created for AKS cluster"
}