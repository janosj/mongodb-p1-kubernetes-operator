echo "Deleting operator..."
kubectl delete deployment mongodb-enterprise-operator -n mongodb

echo "Deleting CRDs..."
kubectl delete crd mongodb.mongodb.com
kubectl delete crd mongodbusers.mongodb.com
kubectl delete crd opsmanagers.mongodb.com

echo "Deleting MongoDB namespace..."
kubectl delete namespace mongodb

