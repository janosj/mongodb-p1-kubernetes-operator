# kubectl delete -f <file> reverses the apply

echo Deleting MongoDB resources...
kubectl delete mdb --all -n monogdb

echo Deleting operator...
kubectl delete deployment mongodb-enterprise-operator -n mongodb

echo Deleting CRD..
kubectl delete crd mongodb.mongodb.com
kubectl delete crd mongodbusers.mongodb.com
kubectl delete crd opsmanagers.mongodb.com

echo Deleting entire MongoDB namespace...
kubectl delete namespace mongodb

