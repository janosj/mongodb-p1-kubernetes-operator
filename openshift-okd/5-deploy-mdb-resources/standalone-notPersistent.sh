# Deploys a standalone without persistent storage.
# Useful for testing if you haven't yet worked out 
# persistent storage in your Kubernetes cluster.

source env.conf
source $OPS_MGR_SETTINGS_FILE
CONFIG_MAP=cm-standalone1

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
  projectName: Kubernetes Standalone 1
  baseUrl: $OPSMGR_URL
  orgId: $OPSMGR_ORG
EOF

echo
echo VERIFY ConfigMap:
kubectl get configmap $CONFIG_MAP -o yaml --namespace=mongodb
echo
echo
echo "Deploying Standalone 1..."

cat <<EOF | kubectl apply -n mongodb -f -
#
# This is a minimal config. To see all the options available, refer to the
# "extended" directory
#
---
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: mdb-standalone-1
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
  persistent: false
EOF

echo
echo "To DELETE: kubectl delete mdb mdb-standalone-1 -n mongodb"
echo "To DELETE: kubectl delete configmap $CONFIG_MAP -n mongodb"
echo
echo "Status:"
kubectl get pods -n mongodb -w

