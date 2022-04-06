CONFIG_MAP=cm-rs1

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
  projectName: K8s RS1
  baseUrl: http://ip-172-31-48-13.ec2.internal:8080
  orgId: 60873c4dc6f0c14e32c8e363
EOF

echo
echo VERIFY ConfigMap:
kubectl get configmap $CONFIG_MAP -o yaml --namespace=mongodb
echo
echo

echo "Deploying Replica Set 1 ..."
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: rs1
spec:
  members: 3
  version: 4.2.5-ent
  type: ReplicaSet

  opsManager:
    configMapRef:
      name: $CONFIG_MAP
  credentials: opsmgr-credentials

  persistent: false

  podSpec:
    # 'podTemplate' allows to set custom fields in PodTemplateSpec.
    # (https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.17/#podtemplatespec-v1-core)
    # for the Database StatefulSet.
    podTemplate:
      spec:
        containers:
          - name: mongodb-enterprise-database
            resources:
              limits:
                cpu: "2"
                memory: 700M
              requests:
                cpu: "1"
                memory: 500M
EOF

echo
echo "To DELETE: kubectl delete mdb rs1 -n mongodb"
echo
echo "Status:"
kubectl get pods -n mongodb -w

