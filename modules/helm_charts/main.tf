
provider "helm" {
  kubernetes {
    host                   = var.host
    username               = var.username
    password               = var.password
    client_certificate     = var.client_certificate
    client_key             = var.client_key
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

# https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/
# Config values ^^

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "kube-system"
  repository = "oci://ghcr.io/nginxinc/charts/"
  chart      = "nginx-ingress"
  set {
    name  = "controller.replicaCount"
    value = 1
  }
  set {
    name  = "controller.healthStatus"
    value = "true"
  }
  set {
    name  = "controller.enableCertManager"
    value = "true"
  }
  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "controller.keda.enabled"
    value = "true"
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  version          = "1.14.1"
  timeout          = 120
  cleanup_on_fail  = true
  #recreate_pods = true
  set {
    name  = "startupapicheck.timeout"
    value = "5m"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

# https://artifacthub.io/packages/helm/opensearch-project-helm-charts/opensearch
# resource "helm_release" "opensearch" {
#   name             = "opensearch"
#   namespace        = "opensearch"
#   repository       = "https://opensearch-project.github.io/helm-charts"
#   chart            = "opensearch"
#   create_namespace = true
#   version          = "2.18.0"
#   timeout          = 120
#   cleanup_on_fail  = true
#   values = [
#     "${file("./modules/helm_charts/values.yaml")}",
#     "${file("./modules/helm_charts/security.yaml")}"
#   ]
# }

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "kube-system"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
}

# Keda is used for hosting Azure Functions on an AKS cluster
# Didn't really work when I tried it, unable to deploy a function using "func kubernetes deploy"
# # https://github.com/kedacore/charts
# resource "helm_release" "keda_runtime" {
#   name             = "keda"
#   namespace        = "keda"
#   repository       = "https://kedacore.github.io/charts/"
#   chart            = "keda"
#   create_namespace = true
#   set {
#     name  = "installCDRs"
#     value = "true"
#   }
# }