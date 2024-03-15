output "helm_dependency" {
  value = helm_release.nginx_ingress.status
}