echo
echo Creating secret...

# Set user to the public key, something like "user=PWOMWMVO"
# Set publicApiKey to the private key, something like "publicApiKey=d7a664e8-b6b6-45fe-845a-ee4fd35c9636"

kubectl -n mongodb create secret generic opsmgr-credentials --from-literal="user=BIIQVGVA" --from-literal="publicApiKey=8dd22433-3510-408d-b1ad-5c3a3daeb134"

echo
echo VERIFY:
kubectl get secrets --namespace=mongodb

# To DELETE:
# kubectl delete secret opsmgr-credentials -n mongodb

