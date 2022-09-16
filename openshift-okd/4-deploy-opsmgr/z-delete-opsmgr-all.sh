echo "Deleting OM..."
kubectl delete om ops-manager -n mongodb

echo "Deleting Ops Manager credentials..."
kubectl delete secret opsmgr-credentials -n mongodb
kubectl delete secret ops-manager-admin-secret -n mongodb

echo
echo "Ops Manager deleted."
echo "Note: Operator, CRDs, and MongoDB Namespace have NOT been deleted."
echo

