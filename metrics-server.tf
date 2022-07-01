resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.metrics-server_helm_version
  namespace  = "kube-system"

  values = [
    "${file("${path.module}/resources/metrics-server/values.yaml")}"
  ]
}
