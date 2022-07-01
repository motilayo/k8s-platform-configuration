resource "kubernetes_namespace" "metallb-system" {
  metadata {
    name = "metallb-system"
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = var.metallb_helm_version
  namespace  = kubernetes_namespace.metallb-system.id

  values = [
    "${file("${path.module}/resources/ingress/metallb-values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.metallb-system
  ]
}

resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress-nginx_helm_version
  namespace  = kubernetes_namespace.ingress-nginx.id

  values = [
    "${file("${path.module}/resources/ingress/ingress-nginx-values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
}
