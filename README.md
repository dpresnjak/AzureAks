# Work in Progress/Practicing Terraform
* VPC with Application Gateway in public subnet with Functions and AKS in private
* AKS Cluster with Application Gateway
    * Helm charts for Nginx ingress, Cert Manager, Prometheus
    * OpenSearch and Keda added but commented out (To do...)
* Two Azure Functions with Service Bus triggers
    * First has input and output through Service Bus
    * Second has input from Service Bus
* Flexible PSQL Server and DB
* Storage account, blob, Container Repository

## Tree
    .
    ├── environments
    │   ├── dev
    │   │   └── dev.tfvars
    │   └── prod
    │       └── prod.tfvars
    ├── main.tf
    ├── modules
    │   ├── app_gateway
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── functions
    │   │   ├── doc_extr_func.py
    │   │   ├── doc_proc_func.py
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── helm_charts
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── values.yaml
    │   │   └── variables.tf
    │   ├── kubernetes
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── ssh.tf
    │   │   └── variables.tf
    │   ├── misc
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── monitoring
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── networking
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   └── storage
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── README.md
    └── variables.tf
    
## AKS Login
Azure cluster uses [kubelogin](https://github.com/Azure/kubelogin) for logging into the AKS cluster from a local pc.

After setting up the kubelogin plugin, run the following commands:

    az account set --subscription $SUBSCRIPTION_ID

    az aks get-credentials --resource-group $RG_NAME --name $CLUSTER_NAME --overwrite-existing

    kubelogin convert-kubeconfig -l azurecli

These commands can be found in Azure -> AKS cluster -> Connect

## Providers
    .
    ├── provider[registry.terraform.io/hashicorp/kubernetes] ~> 2.26.0
    ├── provider[registry.terraform.io/azure/azapi] ~> 1.5
    ├── provider[registry.terraform.io/hashicorp/azurerm] ~> 3.0
    ├── provider[registry.terraform.io/hashicorp/random] ~> 3.0
    ├── provider[registry.terraform.io/hashicorp/time] 0.9.1
    ├── provider[registry.terraform.io/hashicorp/helm] 2.12.1
    ├── module.misc
    │   └── provider[registry.terraform.io/hashicorp/azurerm]
    ├── module.monitoring
    │   └── provider[registry.terraform.io/hashicorp/azurerm]
    ├── module.networking
    │   └── provider[registry.terraform.io/hashicorp/azurerm]
    ├── module.storage
    │   └── provider[registry.terraform.io/hashicorp/azurerm]
    ├── module.application_gateway
    │   └── provider[registry.terraform.io/hashicorp/azurerm]
    ├── module.functions
    │   └── provider[registry.terraform.io/hashicorp/azurerm]
    ├── module.helm_charts
    │   └── provider[registry.terraform.io/hashicorp/helm]
    └── module.kubernetes
        ├── provider[registry.terraform.io/hashicorp/azurerm] ~> 3.0
        ├── provider[registry.terraform.io/hashicorp/random] ~> 3.0
        ├── provider[registry.terraform.io/hashicorp/time] 0.9.1
        ├── provider[registry.terraform.io/hashicorp/kubernetes] ~> 2.26.0
        └── provider[registry.terraform.io/azure/azapi] ~> 1.5
