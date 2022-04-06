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
  persistentVolumeReclaimPolicy: Recycle
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
  persistentVolumeReclaimPolicy: Recycle
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
  persistentVolumeReclaimPolicy: Recycle
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data03"
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mdb004
  namespace: mongodb
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  persistentVolumeReclaimPolicy: Recycle
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data04"
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mdb005
  namespace: mongodb
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  persistentVolumeReclaimPolicy: Recycle
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data05"
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mdb006
  namespace: mongodb
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  persistentVolumeReclaimPolicy: Recycle
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data06"
EOF

echo
kubectl get persistentvolumes

