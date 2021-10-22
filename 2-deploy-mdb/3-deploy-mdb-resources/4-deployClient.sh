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
      image: mongo:4.4
      command: ["tail", "-f", "/dev/null"]
      imagePullPolicy: IfNotPresent
  restartPolicy: Always
EOF

echo
echo "To CONNECT to this pod, run:"
echo "  > kubectl exec -it -n mongodb mdb-client /bin/bash"
echo "From within the pod, connect to your MDB instance using the"
echo "connection details provided by Ops Manager."
echo
echo "To DELETE: kubectl delete mdb rs1 -n mongodb"
echo
echo "Checking Status:"
kubectl get pods -n mongodb -w


