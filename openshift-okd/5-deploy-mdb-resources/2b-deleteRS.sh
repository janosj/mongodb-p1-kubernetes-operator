RESOURCE_NAME=mdb-rs
CONFIG_MAP=cm-$RESOURCE_NAME

echo "Deleting MDB resource ($RESOURCE_NAME)..."
kubectl delete mdb $RESOURCE_NAME

# PVCs and PVs are not deleted with the resource.
# Deleting the PVCs will also delete the PVs,
# given the default reclaim policy of DELETE.
echo "Deleting PVCs and PVs..."
kubectl delete pvc data-$RESOURCE_NAME-0
kubectl delete pvc data-$RESOURCE_NAME-1
kubectl delete pvc data-$RESOURCE_NAME-2

echo "Deleting ConfigMap..."
kubectl delete configmap $CONFIG_MAP

echo
echo "Done, but there are still artifacts remaining that will prevent a "
echo "successful redeployment. Specifically, an mms-automation-agent user"
echo "is created, even when authentication is not enabled."
echo "You can see this in Ops Manager (Project > Security > Users)."
echo "This existence of this user will cause issues if you now attempt to"
echo "redeploy this replica set. The RS will deploy, but will get stuck"
echo "in a non-green state without primaries and secondaries."
echo
echo "To redeploy this replica set, delete the project in Ops Manager."
read -n 1 -s -r -p "Press any key to acknowledge and continue."

echo 
echo "The replica set has now been completely removed."
echo

echo "Useful commands:"
echo "kubectl get mdb"
echo "kubectl get pods | grep $RESOURCE_NAME"
echo "kubectl get pvc | grep $RESOURCE_NAME"
echo "kubectl get pv | grep $RESOURCE_NAME"
echo

