apiVersion: terraform.core.oam.dev/v1beta1
kind: Provider
metadata:
  name: aws
  namespace: default
  labels:
    config.oam.dev/catalog: velacore-config
    config.oam.dev/type: terraform-provider
    config.oam.dev/provider: terraform-aws
spec:
  provider: aws
  region: ${AWS_DEFAULT_REGION}
  credentials:
    source: Secret
    secretRef:
      namespace: vela-system
      name: aws-account-creds
      key: credentials
---
apiVersion: v1
kind: Secret
metadata:
  name: aws-account-creds
  namespace: vela-system
  labels:
    config.oam.dev/catalog: velacore-config
    config.oam.dev/type: terraform-provider
    config.oam.dev/provider: terraform-aws
type: Opaque
stringData:
  credentials: |-
    awsAccessKeyID: ${AWS_ACCESS_KEY_ID}
    awsSecretAccessKey: ${AWS_SECRET_ACCESS_KEY}
