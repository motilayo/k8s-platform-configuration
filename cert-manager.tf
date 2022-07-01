resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert-manager_helm_version
  namespace  = kubernetes_namespace.cert-manager.id

  set {
    name  = "installCRDs"
    value = "true"
  }
}

data "kubectl_file_documents" "cert-manager-issuer" {
  content = file("${path.module}/resources/cert-manager/letsencrypt-staging-issuer.yaml")
}

resource "kubectl_manifest" "cert-manager-issuer" {
  count     = length(data.kubectl_file_documents.cert-manager-issuer.documents)
  yaml_body = element(data.kubectl_file_documents.cert-manager-issuer.documents, count.index)
  depends_on = [
    helm_release.cert-manager
  ]
}
