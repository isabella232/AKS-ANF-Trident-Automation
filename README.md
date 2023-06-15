# Terraform Automation for deploying AKS with ANF using NetApp Astra Trident CSI
AKS (Azure Kubernetes Service) is a first-party managed kubernetes offering by Azure allowing for quick and easy setup of the kubernetes cluster. Azure creates and configures the control plane automatically when a new AKS cluster is provisioned.

ANF (Azure NetApp Files) is a high-performance, enterprise-class, metered file-storage service. Follow the steps in this documentation to provision and configure Azure NetApp Files as a persistent volume (PV) option for applications running on the AKS cluster.

Astra Trident is an open-source and fully supported storage orchestrator for containers and Kubernetes distributions, including Red Hat OpenShift. Trident works with the entire NetApp storage portfolio and also supports NFS and iSCSI connections. Trident accelerates the DevOps workflow by allowing end users to provision and manage storage from their NetApp storage systems without requiring intervention from a storage administrator.

This solution aims to provide a one-touch option for users looking to deploy AKS with ANF as the backend storage allowing for dynamic volume provisioning via Astra Trident CSI using terraform. 

## Features
The solution provides the following features:

* Deploy an AKS Cluster
* Deploy Azure NetApp Files (ANF)
* Install and configure Astra Trident
* Deploy a sample application to showcase the integration works end-to-end

## Pre-requisites
Before you begin, ensure that the following prerequisites are met: 

* Ensure that the below packages are installed on the system from where this script is run:
  * Azure CLI
  * Terraform
  * Kubectl
* Connectivity from the machine where the script is run to Azure environment to ensure terraform is able to reach Azure to provision the required constructs
* An Azure account with sufficient permissions to provision AKS, ANF, vnets, subnets and other constructs mentioned in the .tf files



## Solution Architecture

![alt-text](/images/AKS_ANF_Trident_Automation_Architecture.png)

Note: The solution is provided as-is. Please test before deploying to production

## Variable Description

aks-cluster.tfvars :

| Name | Type | Description |
| --- | --- | --- |
| `appId ` | String | (Required) Azure Kubernetes Service Cluster service principal ID |
| `password ` | String | (Required) Azure Kubernetes Service Cluster service principal password |
| `environmentName ` | String | (Required) Environment Name used for AKS |
| `location ` | String | (Required) Region where AKS is deployed |
| `nodeCount ` | String | (Required) Number of nodes needed as part of the AKS cluster |
| `aks_subnet_cidr ` | String | (Required) Enter the CIDR range (/16 subnet) for the Subnet to be created for AKS cluster |
| `azure_subscription_id ` | String | (Required) Enter the Azure Subscription ID to be used |
| `azure_sp_tenant_id ` | String | (Required) Enter the Service Principal Tenant ID to be used |
| `trident_location ` | String | (Required) Region code where AKS is deployed (e.g. "westus" for West US) |


anf.tfvars :

| Name | Type | Description |
| --- | --- | --- |
| `az_location ` | String | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. |
| `az_prefix` | String | (Required) The name of the resource group where the NetApp Volume should be created. Changing this forces a new resource to be created. |
| `az_vnet_primary_address_space` | String | (Required) The address space to be used by the newly created vnet for ANF primary volume deployment. |
| `az_subnet_primary_address_prefix` | String | (Required) The subnet address prefix to be used by the newly created vnet for ANF primary volume deployment. |
| `az_capacity_pool_size_primary` | Integer | (Required) Capacity Pool Size mentioned in TB. |
| `az_netapp_pool_service_level_primary` | String | (Required) The target performance of the file system. Valid values include `Premium` , `Standard` , or `Ultra`. |
| `az_dual_protocol_bool` | String | (Required) True to enable NFS and SMB, False to restrict to a single protocol |
| `az_smb_server_username` | String | (Optional) Username to create ActiveDirectory object. |
| `az_smb_server_password` | String | (Optional) User Password to create ActiveDirectory object. |
| `az_smb_server_name` | String | (Optional) Server Name to create ActiveDirectory object. |
| `az_smb_dns_servers` | String | (Optional) DNS Server IP to create ActiveDirectory object. |



## Deployment Steps

1. Clone the repository:

``` git clone https://github.com/NetApp-Automation/AKS-ANF-Trident-Automation.git```

2. Navigate into the cloned folder:

``` cd AKS-ANF-Trident-Automation/```

3. Update the values of variables required in the *vars* folder (Refer variable description table) and save the files.
   
4. Navigate back to the root of the folder and login to Azure CLI to allow terraform to use the azure account to provision the required constructs:

``` az login ```

5. Initialize terraform:

``` terraform init ```

6. Validate the terraform code

``` terraform validate```

7. Run the plan command to check what constructs will get provisioned based on the variable values assigned:

``` terraform plan --var-file=./vars/aks-cluster.tfvars -var-file=./vars/anf.tfvars```

1. If satisfied with the output of the terraform plan command, run the apply command to start resource provisioning:

``` terraform apply --var-file=./vars/aks-cluster.tfvars -var-file=./vars/anf.tfvars```

*Optional*: To destroy the constructs created by this script, delete any volumes created in ANF manually and run the command:

``` terraform destroy --var-file=./vars/aks-cluster.tfvars -var-file=./vars/anf.tfvars```

## License
By accessing, downloading, installing or using the content in this repository, you agree the terms of the License laid out in License file.

Note that there are certain restrictions around producing and/or sharing any derivative works with the content in this repository. Please make sure you read the terms of the License before using the content. If you do not agree to all of the terms, do not access, download or use the content in this repository.

Copyright: 2023 NetApp Inc.

## Author Information

- [Dhruv Tyagi](mailto:dhruv.tyagi@netapp.com) - NetApp Solutions Engineering Team
- [Niyaz Mohamed](mailto:niyaz.mohamed@netapp.com) - NetApp Solutions Engineering Team
