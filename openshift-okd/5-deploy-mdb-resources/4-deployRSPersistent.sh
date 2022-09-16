source opsmgr.settings.notCommitted
source db.settings
CONFIG_MAP=cm-rs2-persistent

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
  projectName: K8s RS2 Persistent
  baseUrl: $OPSMGR_URL
  orgId: $OPSMGR_ORG
EOF

echo
echo VERIFY ConfigMap:
kubectl get configmap $CONFIG_MAP -o yaml --namespace=mongodb
echo
echo

echo "Deploying Replica Set 2 Persistent ..."
# this requires 3 persistent volumes, 
# either dynamically or statically provisioned.
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: rs2-persistent
spec:
  members: 3
  version: $DB_VERSION
  type: ReplicaSet

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
echo "To DELETE: kubectl delete mdb rs2-persistent -n mongodb"
echo
echo "Status:"
kubectl get pods -n mongodb -w

