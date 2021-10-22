kubectl create -f ebs-storage.yaml -n mongodb

# This will be set as the default automatically.
# Otherwise, to set it as the default:
# kubectl annotate storageclass gp2 storageclass.kubernetes.io/is-default-class=true
# kubectl get storageclass
# see here: https://docs.aws.amazon.com/eks/latest/userguide/storage-classes.html
# To delete:
# kubectl delete storageclass <storage-class>

