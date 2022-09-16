source env.conf

echo
echo Creating MongoDB CustomResourceDefinitions...

# To apply the latest, without downloading:
# kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml

kubectl apply -f $REPO_DIR/crds.yaml

echo
echo Verifying:
kubectl get crd | grep mongo
#kubectl describe crd <crd-name>
#kubectl delete crd <crd-name>
echo

