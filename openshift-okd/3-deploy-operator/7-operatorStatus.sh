# Should list operator as running
kubectl get pods -n mongodb

# Indicates all the containers/images referenced in mongodb-enterprise.yaml
kubectl describe pod mongodb-enterprise-operator -n mongodb

# Retrieve operator logs
# kubectl logs -n mongodb deployment/mongodb-enterprise-operator

