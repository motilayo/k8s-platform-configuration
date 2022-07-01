apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
  namespace: ${crossplane_ns}
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: ${crossplane_ns}
      name: ${aws_creds}
      key: creds