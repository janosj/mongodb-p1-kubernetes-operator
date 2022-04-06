echo Deleting Demo user ...
kubectl delete AtlasDatabaseUser demo-atlas-db-user
kubectl delete secret demo-password

echo Deleting Atlas cluster ...
kubectl delete AtlasCluster  demo-atlas-cluster

echo Deleting Atlas project ...
kubectl delete AtlasProject demo-atlas-project

echo Deleting Atlas Kubernetes Operator ...
kubectl delete deployment mongodb-atlas-operator -n mongodb-atlas-system

echo Deleting namespace ...
kubectl delete namespace mongodb-atlas-system

