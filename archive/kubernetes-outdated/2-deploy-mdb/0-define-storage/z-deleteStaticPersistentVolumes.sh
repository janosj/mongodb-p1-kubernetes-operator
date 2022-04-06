kubectl delete persistentvolume mdb001
kubectl delete persistentvolume mdb002
kubectl delete persistentvolume mdb003
kubectl delete persistentvolume mdb004
kubectl delete persistentvolume mdb005
kubectl delete persistentvolume mdb006

echo "Verify:"
kubectl get persistentvolumes

