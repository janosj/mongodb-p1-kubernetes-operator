# Makes a Mongo shell available for use to test connectivity
# within the Kubernetes cluster to the deployed MDB resources.
# No Ops Manager connection required. 

echo "Deploying MongoDB client ..."

cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: v1
kind: Pod
metadata:
  name: mdb-client
spec:
  containers:
    - name: mdb-client
      image: mongo:latest
      command: ["tail", "-f", "/dev/null"]
      imagePullPolicy: IfNotPresent
  restartPolicy: Always
EOF

echo
echo "To CONNECT to this pod, run:"
echo "  > kubectl exec -it -n mongodb mdb-client -- /bin/bash"
echo
echo "Then, from within the pod, connect to your MDB instance using "
echo "MONGOSH with the connection details provided by Ops Manager."
echo
echo "To DELETE: kubectl delete pod mdb-client -n mongodb"
echo
echo "Checking Status:"
kubectl get pods -n mongodb -w


