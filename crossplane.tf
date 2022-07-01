resource "kubernetes_namespace" "crossplane-system" {
  metadata {
    name = "crossplane-system"
  }
}

resource "helm_release" "crossplane" {
  name       = "crossplane"
  repository = "https://charts.crossplane.io/stable"
  chart      = "crossplane"
  version    = var.crossplane_helm_version
  namespace  = kubernetes_namespace.crossplane-system.id

}

resource "kubernetes_secret" "aws-creds" {
  metadata {
    name      = "aws-creds"
    namespace = kubernetes_namespace.crossplane-system.id
  }
  data = {
    creds = templatefile("${path.module}/aws-credentials.tpl",
      {
        aws_access_key_id     = aws_iam_access_key.k8s-admin-acc-keys.id,
        aws_secret_access_key = aws_iam_access_key.k8s-admin-acc-keys.secret,
        aws_region            = data.aws_region.current.name
      }
    )
  }

  depends_on = [
    kubernetes_namespace.crossplane-system
  ]
}

resource "kubernetes_manifest" "provider-jet-aws" {
  manifest = yamldecode(
    templatefile("${path.module}/resources/crossplane/provider-jet-aws.tpl",
      {
        provider_jet_aws_version = var.provider_jet_aws_version,
        crossplane_ns            = kubernetes_namespace.crossplane-system.id
      }
    )
  )
}

data "kubectl_file_documents" "provider-config-jet-aws" {
  content = templatefile("${path.module}/resources/crossplane/provider-config-jet-aws.tpl",
    {
      crossplane_ns = kubernetes_namespace.crossplane-system.id,
      aws_creds     = element(split("/", kubernetes_secret.aws-creds.id), 1)
    }
  )
}

resource "kubectl_manifest" "provider-config-jet-aws" {
  count     = length(data.kubectl_file_documents.provider-config-jet-aws.documents)
  yaml_body = element(data.kubectl_file_documents.provider-config-jet-aws.documents, count.index)
  depends_on = [
    kubernetes_manifest.provider-jet-aws
  ]
}
