source env.conf
source $OPS_MGR_SETTINGS_FILE

RESOURCE_NAME=mdb-standalone
CONFIG_MAP=cm-$RESOURCE_NAME

echo
echo "Creating Config Map $CONFIG_MAP ..."

# To see file with replacements, use: cat <<EOF | cat > file1
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: $CONFIG_MAP
data:
  projectName: K8s Standalone
  baseUrl: $OPSMGR_URL
  orgId: $OPSMGR_ORG
EOF

echo
echo VERIFY ConfigMap:
kubectl get configmap $CONFIG_MAP -o yaml --namespace=mongodb
echo
echo

echo "Deploying standalone MDB ..."
# Complete 1.16 resource spec is here: 
# https://www.mongodb.com/docs/kubernetes-operator/v1.16/reference/k8s-operator-specification/ 
# Requires 1 persistent volume (dynamically or statically provisioned).
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: $RESOURCE_NAME
spec:
  version: $DB_VERSION
  type: Standalone
  # Before you create this object, you'll need to create a project ConfigMap and a
  # credentials Secret. For instructions on how to do this, please refer to our
  # documentation, here:
  # https://docs.opsmanager.mongodb.com/current/tutorial/install-k8s-operator
  opsManager:
    configMapRef:
      name: $CONFIG_MAP
  credentials: opsmgr-credentials

  # This flag allows the creation of pods without persistent volumes. This is for
  # testing only, and must not be used in production. 'false' will disable
  # Persistent Volume Claims. The default is 'true'
  persistent: true

  resources:
    cpu: '0.25'
    memory: 512M
    storage: 8Gi
    # storage_class: basic

EOF

echo
echo "To DELETE: kubectl delete mdb $RESOURCE_NAME -n mongodb"
echo
echo "Status:"
kubectl get pods -n mongodb -w

