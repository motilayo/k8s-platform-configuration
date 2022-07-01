variable "crossplane_helm_version" {
  description = "crossplane helm chart version"
  default     = "1.8.1"
}

variable "provider_jet_aws_version" {
  description = "provider jet aws version"
  default     = "v0.4.2"
}

variable "metallb_helm_version" {
  description = "metallb helm chart version"
  default     = "0.12.1"
}

variable "ingress-nginx_helm_version" {
  description = "ingress-nginx helm chart version"
  default     = "4.1.2"
}

variable "kubevela_helm_version" {
  description = "kubevela helm chart version"
  default     = "1.4.4"
}

variable "vela_cli_version" {
  description = "vela cli version"
  default     = "1.4.4"
}

variable "velaux_version" {
  description = "velaux version"
  default     = "1.4.4"
}

variable "terraform_controller_version" {
  description = "terraform controller version"
  default     = "0.7.3"
}

variable "cert-manager_helm_version" {
  description = "cert-manager helm chart version"
  default     = "1.8.0"
}

variable "metrics-server_helm_version" {
  description = "metrics-server helm chart version"
  default     = "3.8.2"
}