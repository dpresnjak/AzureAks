#https://learn.microsoft.com/en-us/azure/aks/private-clusters?tabs=azure-portal

terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.26.0"
    }
  }
}

provider "kubernetes" {
  username               = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.username
  password               = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.password
  host                   = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.cluster_ca_certificate)
}
data "kubernetes_service" "ingress_ip" {
  depends_on = [
    azurerm_kubernetes_cluster.k8s_cluster,
    var.helm_dependency
  ]
  metadata {
    name      = "ingress-nginx-nginx-ingress-controller"
    namespace = "kube-system"
  }
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  location                            = var.location
  name                                = var.aks_cluster_name
  resource_group_name                 = var.rg_name
  dns_prefix                          = var.prefix
  private_cluster_enabled             = false
  private_cluster_public_fqdn_enabled = false
  sku_tier                            = "Standard"
  # key_management_service {
  #   key_vault_key_id = var.key_vault_id
  #   key_vault_network_access = "Private"
  # }
  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = ["bce11c02-1d67-42fb-a722-b359703e9984"]
    azure_rbac_enabled     = true
  }
  identity {
    type = "SystemAssigned"
  }
  default_node_pool {
    name                         = "agentpool"
    vm_size                      = var.aks_agent_vm_size
    node_count                   = var.node_count
    enable_node_public_ip        = false
    vnet_subnet_id               = var.private_sub_id
    only_critical_addons_enabled = false
    temporary_name_for_rotation  = "tempname"
  }
  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = var.aks_service_cidr
    dns_service_ip    = var.aks_dns_service_ip
    outbound_type     = "loadBalancer"
    # load_balancer_profile {
    #   outbound_ip_address_ids = [ var.app_gateway_public_ip_id ]
    # }
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.k8s_cluster.identity.0.principal_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "sbus_perms_proc" {
  principal_id         = azurerm_kubernetes_cluster.k8s_cluster.identity.0.principal_id
  role_definition_name = "Azure Service Bus Data Owner"
  scope                = var.sbus_proc_queue_id
}
resource "azurerm_role_assignment" "sbus_perms_extr" {
  principal_id         = azurerm_kubernetes_cluster.k8s_cluster.identity.0.principal_id
  role_definition_name = "Azure Service Bus Data Owner"
  scope                = var.sbus_extr_queue_id
}