provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@hub-cluster"
}

provider "aws" {
  region = "ca-central-1"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
}