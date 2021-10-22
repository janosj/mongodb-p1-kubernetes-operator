# Verify OM deployment
kubectl get om -n mongodb -w

# Verify pods:
kubectl get pods -n mongodb -w

# Determine Ops Manager port:
kubectl get service --all-namespaces

