apiVersion: v1
kind: ConfigMap
metadata:
  name: vela-addon-registry
  namespace: ${vela_ns}
data:
  registries: '{
  "KubeVela":{
    "name": "KubeVela",
    "helm": {
      "url": "https://addons.kubevela.net"
    }
  }
}'