apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-jet-aws
spec:
  package: crossplane/provider-jet-aws:${provider_jet_aws_version}
  packagePullPolicy: IfNotPresent
  revisionActivationPolicy: Automatic
  revisionHistoryLimit: 1