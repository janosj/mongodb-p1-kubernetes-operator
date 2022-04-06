# Deploy Atlas Kubernetes Operator:
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-atlas-kubernetes/main/deploy/all-in-one.yaml

# Verify
# Shows the operator deployed (by default) into the mongodb-atlas-system namespace.
kubectl get pods --all-namespaces -w

