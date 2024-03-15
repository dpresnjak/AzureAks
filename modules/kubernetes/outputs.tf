# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_certificate
#   sensitive = true
# }
# output "client_key" {
#   value     = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_key
#   sensitive = true
# }
# output "cluster_ca_certificate" {
#   value     = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.cluster_ca_certificate
#   sensitive = true
# }
# output "cluster_password" {
#   value     = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.password
#   sensitive = true
# }
# output "cluster_username" {
#   value = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.username
#   sensitive = true
# }
# output "host" {
#   value     = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.host
#   sensitive = true
# }

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.client_certificate
  sensitive = true
}
output "client_key" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.client_key
  sensitive = true
}
output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.cluster_ca_certificate
  sensitive = true
}
output "cluster_password" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.password
  sensitive = true
}
output "cluster_username" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.username
  sensitive = true
}
output "host" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config.0.host
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw
  sensitive = true
}
output "kube_admin_config_raw" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config_raw
}
output "kube_admin_config" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_admin_config
}
output "k8s_fqdn" {
  value = azurerm_kubernetes_cluster.k8s_cluster.fqdn
}
output "private_fqdn" {
  value = azurerm_kubernetes_cluster.k8s_cluster.private_fqdn
}
output "portal_fqdn" {
  value = azurerm_kubernetes_cluster.k8s_cluster.portal_fqdn
}
output "k8s_principal_id" {
  value = azurerm_kubernetes_cluster.k8s_cluster.identity.0.principal_id
}
output "key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}
output "pvt_key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
}
output "ingress_ip" {
  value = data.kubernetes_service.ingress_ip.status.0.load_balancer.0.ingress[0].ip
}