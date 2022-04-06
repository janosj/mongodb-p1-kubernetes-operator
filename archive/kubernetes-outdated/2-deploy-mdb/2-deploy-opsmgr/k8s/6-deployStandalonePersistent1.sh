CONFIG_MAP=cm-persistent-static-1
ORG_ID=60a5243602cb1a0071ad345e

# Figure out the URL to use.
# kubectl get om ops-manager -o jsonpath='{.status.opsManager.url}'


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
  projectName: K8sPersistentStatic1
  baseUrl: http://ops-manager-svc.mongodb.svc.cluster.local:8080
  orgId: $ORG_ID
EOF

echo
echo VERIFY ConfigMap:
kubectl get configmap $CONFIG_MAP -o yaml --namespace=mongodb
echo
echo

echo "Deploying Persistent Standalone 1 ..."
# Requires 1 persistent volume,
# either dynamically or statically provisioned.
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: mdb-persistent-standalone-1
spec:
  version: 4.2.5-ent
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
echo "To DELETE: kubectl delete mdb mdb-persistent-standalone-1 -n mongodb"
echo
echo "Status:"
kubectl get pods -n mongodb -w

