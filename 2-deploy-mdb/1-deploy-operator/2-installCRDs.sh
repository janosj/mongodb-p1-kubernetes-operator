echo
echo Creating MongoDB CustomResourceDefinitions...

# Latest
# kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml

# 1.5.3
kubectl apply -f downloaded-repo-1.5.3/crd.1.5.3.yaml

echo Verifying:
kubectl get crd
#kubectl describe crd <crd-name>
#kubectl delete crd <crd-name>

