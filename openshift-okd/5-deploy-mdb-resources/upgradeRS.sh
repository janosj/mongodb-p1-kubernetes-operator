source env.conf
source $OPS_MGR_SETTINGS_FILE
RESOURCE_NAME=$RS_NAME
CONFIG_MAP=cm-$RESOURCE_NAME

echo
echo VERIFY ConfigMap:
kubectl get configmap $CONFIG_MAP -o yaml --namespace=mongodb
echo
echo

echo "Upgrading 3-Node Replica Set $RESOURCE_NAME ..."
echo "Note: this could fail if the version manifest in Ops Manager is out of date."
echo

# Complete 1.16 resource spec is here:
# https://www.mongodb.com/docs/kubernetes-operator/v1.16/reference/k8s-operator-specification/
# Requires 3 persistent volumes, either dynamically or statically provisioned.
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: $RESOURCE_NAME
spec:
  members: 3
  version: 6.0.2-ent
  type: ReplicaSet
  statefulSet:
    spec:
      serviceName: $SERVICE_NAME

  opsManager:
    configMapRef:
      name: $CONFIG_MAP
  credentials: opsmgr-credentials

  persistent: true

  resources:
    cpu: '0.25'
    memory: 512M
    storage: 8Gi
    #storage_class: basic
EOF

echo
echo "To DELETE: kubectl delete mdb $RESOURCE_NAME -n mongodb"
echo
echo "Status:"
kubectl get pods -n mongodb -w

