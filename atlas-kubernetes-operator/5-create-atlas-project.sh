cat <<EOF | kubectl apply -f -
apiVersion: atlas.mongodb.com/v1
kind: AtlasProject
metadata:
  name: demo-atlas-project
spec:
  name: DEMO Atlas K8s Operator Project
  projectIpAccessList:
    - ipAddress: "0.0.0.0/0"
      comment: "Allowing access to database from everywhere (only for Demo!)"
EOF

# Verify:
kubectl get AtlasProject --all-namespaces

# Or:
# kubectl get AtlasProject demo-atlas-project

echo
echo "Check Atlas for Project creation."
echo "If the new project isn't listed, check the Operator logs."
echo

