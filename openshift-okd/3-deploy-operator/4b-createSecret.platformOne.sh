# Kubernetes docs: Pull an image from a Private Registry
# https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

# The secret has to be created in the mongodb namespace.
# Seems tricky to modify the file to enable this.
# Setting the default namespace for all kubectl commands solves the problem.
kubectl config set-context --current --namespace=mongodb

# The secret file is generated on the kubernetes cluster.
# Run "sudo docker login https://registry1.dso.mil"
# Transfer the file k81:/root/.docker/config.json to local:./dockerSecret.json

kubectl create secret generic registry1-credentials \
    --from-file=.dockerconfigjson=auth.platformOne.json.notCommitted \
    --type=kubernetes.io/dockerconfigjson

# Unset the default namespace.
# Not necessary, but I prefer to specify the namespace manually.
kubectl config set-context --current --namespace=""

# Verify
kubectl get secret -n mongodb
kubectl get secret registry1-credentials -n mongodb --output=yaml

# To DELETE:
# kubectl delete secret registry1-credentials -n mongodb

