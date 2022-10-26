source env.conf

echo "This script deploys the MongoDB Kubernetes Operator by applying"
echo "the mongodb-enterprise.yaml file via kubectl."
echo "Multiple versions of this mongodb-enterprise.yaml file have been"
echo "created to support multiple environments and purposes."
echo
echo "Please select from the following list of options: "
echo " 1) Use publicly available (standard) images"
echo " 2) Use modified images pushed to test repo on Quay.io."
echo " 3) Use Iron Bank images."

read n
case $n in
 1) echo "Using publicly available images..."
    YAML_FILE=mongodb-enterprise-openshift.1.pullSecret.yaml
    ;;
 2) echo "Using modified images from test repo on Quay.io..."
    YAML_FILE=mongodb-enterprise-openshift.2.p1-quaytest.yaml
    ;;
 3) echo "Using Iron Bank images..."
    YAML_FILE=mongodb-enterprise-openshift.3.p1-ironbank.yaml
    ;;
 *) echo "Invalid option. Exiting."
    exit 1
    ;;
esac

if ! [ -f "$YAML_DIR/$YAML_FILE" ]; then
    echo "$YAML_DIR/$YAML_FILE does not exist."
    echo "Run createYamlVariants.sh and try again."
    echo "Operation cancelled."
    exit 1
fi

echo "Using file $YAML_FILE..."
kubectl apply -n mongodb -f $YAML_DIR/$YAML_FILE

# This would apply the latest from the repo
# kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml -n mongodb

echo
echo Verify:
kubectl describe deployments mongodb-enterprise-operator -n mongodb
echo

#output=wide tells you where the pod is running (i.e. which node)
kubectl get pods --namespace=mongodb --output=wide -w

# To DELETE:
# kubectl delete deployment mongodb-enterprise-operator -n mongodb

