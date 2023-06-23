# AKS Vars

variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

variable "location" {
  description = "Region where AKS is deployed"
}

variable "nodeCount" {
  description = "Number of nodes needed as part of the AKS cluster"
}

variable "aks_subnet_cidr" {
  description = "Enter the CIDR range (/16 subnet) for the Subnet to be created for AKS cluster"
}

variable "azure_subscription_id" {
  description = "Azure Account Subscription ID"
}

variable "azure_sp_tenant_id" {
  description = "Tenant ID of Azure Service Principal"
}

variable "trident_location" {
  description = "Region where Trident storage backend is being configured"
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

variable "az_subnet_primary_address_prefix" {
    description = "The address prefix used to create the primary subnet"
}

variable "az_capacity_pool_size_primary" {
  description = "Enter the size in Tb for the primary netapp capacity pool"
}

variable "az_netapp_pool_service_level_primary" {
  description = "Enter the primary service level for creating the netapp pool"
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