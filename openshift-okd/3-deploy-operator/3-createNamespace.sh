echo
echo Creating mongodb namespace...
kubectl create namespace mongodb

echo
echo verifying:
kubectl get namespace | grep mongo
echo

kubectl config set-context $(kubectl config current-context) --namespace=mongodb
echo "Default namespace set to mongodb."
echo

# To VALIDATE:
# kubectl config view --minify | grep namespace:

# To DELETE:
# kubectl delete namespace mongodb


