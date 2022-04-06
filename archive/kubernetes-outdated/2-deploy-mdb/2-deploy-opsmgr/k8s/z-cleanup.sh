echo "Deleting test MongoDB standalone deployment..."
kubectl delete mdb mdb-persistent-standalone-1 -n mongodb
kubectl delete configmap cm-persistent-static-1 -n mongodb
kubectl delete pvc data-mdb-persistent-standalone-1-0 -n mongodb

echo "Deleting OM..."
kubectl delete om ops-manager -n mongodb

echo "Deleting Ops Manager credentials..."
kubectl delete secret opsmgr-credentials -n mongodb
kubectl delete secret ops-manager-firstuser-secret -n mongodb

echo "Deleting Persistent Volume claims..."
kubectl delete pvc data-ops-manager-db-0 -n mongodb
kubectl delete pvc data-ops-manager-db-1 -n mongodb
kubectl delete pvc data-ops-manager-db-2 -n mongodb
kubectl delete pvc head-ops-manager-backup-daemon-0 -n mongodb

echo
echo "Ops Manager deleted."
echo "Note: Operator, CRDs, and MongoDB Namespace have NOT been deleted."
echo "Be sure to delete any files in the persistent volume directories on each K8s node."

