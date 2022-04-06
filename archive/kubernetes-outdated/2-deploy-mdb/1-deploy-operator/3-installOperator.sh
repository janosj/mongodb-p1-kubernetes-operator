echo
echo Installing MongoDB Enterprise Kubernetes Operator...

# Latest
# kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml -n mongodb

# 1.5.3
kubectl apply -f downloaded-repo-1.5.3/mongodb-enterprise.1.5.3.yaml

echo Verify:
kubectl describe deployments mongodb-enterprise-operator -n mongodb

#output=wide tells you where the pod is running (i.e. which node)
kubectl get pods --namespace=mongodb --output=wide -w

# To DELETE:
# kubectl delete deployment mongodb-enterprise-operator -n mongodb
