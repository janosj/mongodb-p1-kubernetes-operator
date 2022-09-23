source env.conf
#export KUBECONFIG

echo "This script deploys the MongoDB Ops Manager by applying"
echo "the ops-manager.yaml file via kubectl."
echo "Multiple versions of this ops-manager.yaml file have been"
echo "created to support multiple environments and tests."
echo
echo "Please select from the following list of options: "
echo
echo " 1) Basic config with default *remote* mode to do an intial smoke test."
echo "    Uses *standard containers* if the operator was deployed using"
echo "    mongodb-enterprise-openshift.1.quickstart-mods.yaml."
echo
echo " 2) Uses *test containers* on quay.io."
echo "    Uses the default *remote* mode (i.e. downloads binaries from mongodb.com)."
echo "    Test containers use a single agent, necessitating another yaml edit."
echo "    Operator must have been deployed with mongodb-enterprise-openshift.2.p1-quaytest.yaml."
echo
echo " 3) Uses *test containers* on quay.io."
echo "    Switches to *local* mode, leveraging the db-binaries container."
echo "    Must again use quay test yaml: mongodb-enterprise-openshift.2.p1-quaytest.yaml."
echo
echo " 4) Full test of the submitted *Iron Bank images* in *Local mode*."
echo "    Use in conjunction with mongodb-enterprise-openshift.3.platform-one.yaml."
echo 
read n
case $n in
 1) echo "Using STANDARD containers in REMOTE mode..."
    echo "(Must have deployed Operator using mongodb-enterprise-openshift.1.pullSecret.yaml)"
    YAML_FILE=om.1.smoketest.remote.yaml
    ;;
 2) echo "Using TEST containers in REMOTE mode (single agent)..."
    echo "(Must have deployed Operator using mongodb-enterprise-openshift.2.p1-quaytest.yaml)"
    YAML_FILE=om.2.remote.singleAgent.quay.yaml
    # Requires a config change to use a single version of the mongodb-agent.
    ;;
 3) echo "Using TEST containers in LOCAL mode..."
    echo "(Must have deployed Operator using mongodb-enterprise-openshift.2.p1-quaytest.yaml)"
    YAML_FILE=om.3.local.singleAgent.quay.yaml
    ;;
 4) echo "Using submitted Iron Bank containers in LOCAL mode..."
    echo "(Must have deployed Operator using mongodb-enterprise-openshift.3.p1-ironbank.yaml)"
    YAML_FILE=om.4.local.singleAgent.ironbank.yaml
    ;;
 *) echo "Invalid option. Exiting."
    exit 1
    ;;
esac

if ! [ -f "$YAML_DIR/$YAML_FILE" ]; then
    echo "$YAML_DIR/$YAML_FILE does not exist."
    echo "Operation cancelled."
    exit 1
fi

echo "Using file $YAML_FILE..."
kubectl apply -n mongodb -f $YAML_DIR/$YAML_FILE

echo
echo "See script for additional status commands."
echo
echo "Showing pod status:"
kubectl get pods -w

# These assume the default namespace is set to mongodb.
# Otherwise, add "-n mongodb"

# Verify OM deployment
# kubectl get om -w
# kubectl get om -o yaml -w

# Verify persistent volumes and claims
# kubectl get pvc
# kubectl get pv

# Determine Ops Manager URL and port:
# kubectl get service

# To DELETE:
# kubectl delete om ops-manager

