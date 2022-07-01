terraform {
  backend "local" {
    path = ".tfstate/hub-cluster.tfstate"
  }
}
resource "aws_iam_user" "k8s-admin" {
  name = "k8s-admin"
}

resource "aws_iam_user_policy_attachment" "k8s-admin-policy-attachment" {
  user       = aws_iam_user.k8s-admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "k8s-admin-acc-keys" {
  user = aws_iam_user.k8s-admin.name
}

data "aws_region" "current" {}
