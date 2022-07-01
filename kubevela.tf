resource "kubernetes_namespace" "vela-system" {
  metadata {
    name = "vela-system"
  }
}

resource "helm_release" "kubevela" {
  name       = "kubevela"
  repository = "https://charts.kubevela.net/core"
  chart      = "vela-core"
  version    = var.kubevela_helm_version
  namespace  = kubernetes_namespace.vela-system.id

  values = [
    "${file("${path.module}/resources/kubevela/vela-core-values.yaml")}"
  ]

  depends_on = [
    helm_release.cert-manager
  ]
}

# resource "kubernetes_manifest" "vela-addon-registry" {
#   manifest = yamldecode(templatefile("${path.module}/resources/kubevela/addon-registry.tpl",
#     {
#       vela_ns = kubernetes_namespace.vela-system.id
#     }
#   ))
# }

resource "null_resource" "vela-cli" {
  provisioner "local-exec" {
    command = "curl -fsSl https://kubevela.io/script/install.sh | bash -s ${var.vela_cli_version}"
  }

  depends_on = [
    helm_release.kubevela
  ]
}

resource "null_resource" "velaux" {
  provisioner "local-exec" {
    command = "vela addon enable velaux --version v${var.velaux_version}"
  }

  depends_on = [
    null_resource.vela-cli,
    helm_release.kubevela
    # kubernetes_manifest.vela-addon-registry
  ]
}

// added because velaux deployment doesnt support arm64 currently
resource "null_resource" "patch-velaux" {
  provisioner "local-exec" {
    command = "kubectl set image deployment/velaux -n ${kubernetes_namespace.vela-system.id} velaux=jm98/velaux:v${var.velaux_version}-arm64"
  }

  depends_on = [
    null_resource.velaux
  ]
}

resource "kubernetes_manifest" "velaux-ingress" {
  manifest = yamldecode(file("${path.module}/resources/kubevela/velaux-ingress.yaml"))
}

resource "helm_release" "terraform-controller" {
  name       = "terraform-controller"
  repository = "https://charts.kubevela.net/addons"
  chart      = "terraform-controller"
  version    = var.terraform_controller_version
  namespace  = kubernetes_namespace.vela-system.id

  values = [
    "${file("${path.module}/resources/kubevela/terraform-values.yaml")}"
  ]

  depends_on = [
    helm_release.kubevela
  ]
}

// create aws-provider.tpl from aws-provider.cue
// cue export aws-provider.cue -e template.output -e template.outputs.credential --out yaml > aws-provider.tpl 
data "local_file" "aws-provider-tpl" {
  filename = "${path.module}/resources/kubevela/aws-provider.tpl"
}

data "kubectl_file_documents" "aws-provider" {
  content = templatefile(data.local_file.aws-provider-tpl.filename,
    {
      AWS_ACCESS_KEY_ID     = aws_iam_access_key.k8s-admin-acc-keys.id
      AWS_SECRET_ACCESS_KEY = aws_iam_access_key.k8s-admin-acc-keys.secret
      AWS_DEFAULT_REGION    = data.aws_region.current.name
    }
  )

}

resource "kubectl_manifest" "aws-provider" {
  for_each = data.kubectl_file_documents.aws-provider.manifests
  yaml_body = each.value
}