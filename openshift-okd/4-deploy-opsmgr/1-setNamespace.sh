kubectl config set-context $(kubectl config current-context) --namespace=mongodb

echo
echo "Verifying - current namespace is set to:"
kubectl config view --minify | grep namespace:
echo

