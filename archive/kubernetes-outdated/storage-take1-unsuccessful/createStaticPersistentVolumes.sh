cat <<EOF | kubectl apply -f -
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mdb001
  namespace: mongodb
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  persistentVolumeReclaimPolicy: Delete
  storageClassName: basic
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data01"

---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mdb002
  namespace: mongodb
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  persistentVolumeReclaimPolicy: Delete
  storageClassName: basic
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data02"

---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mdb003
  namespace: mongodb
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  persistentVolumeReclaimPolicy: Delete
  storageClassName: basic
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data03"
EOF

