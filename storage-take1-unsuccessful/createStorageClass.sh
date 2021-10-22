# From: https://github.com/10gen/ops-manager-kubernetes/blob/master/docs/using_static_persistent_volumes.md

cat <<EOF | kubectl apply -f -
---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: basic
  namespace: mongodb
provisioner: kubernetes.io/no-provisioner
EOF

# Verify:
kubectl get sc

