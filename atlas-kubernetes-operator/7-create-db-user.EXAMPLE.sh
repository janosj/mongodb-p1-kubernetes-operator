kubectl create secret generic demo-password --from-literal="password=d3m0M10wnPassw0rd"

# This required step is not in the guide.
kubectl label secret demo-password atlas.mongodb.com/type=credentials

cat <<EOF | kubectl apply -f -
apiVersion: atlas.mongodb.com/v1
kind: AtlasDatabaseUser
metadata:
  name: demo-atlas-db-user
spec:
  roles:
    - roleName: "readWriteAnyDatabase"
      databaseName: "admin"
  projectRef:
    name: demo-atlas-project
  username: demok8user
  passwordSecretRef:
    name: demo-password
EOF

# Verify:
kubectl get atlasdatabaseusers demo-atlas-db-user -o=jsonpath='{.status.conditions[?(@.type=="Ready")].status}'

# Users are listed in the Atlas UI under Database Access for the project.

