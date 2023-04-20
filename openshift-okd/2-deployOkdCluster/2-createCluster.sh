source env.conf

if ! [ -f "$CONFIG_FILE" ]; then
  echo "ERROR: config file '$CONFIG_FILE' does not exist."
  echo "Run createConfig first."
  echo "Exiting. Cluster not created."
  exit 1
fi

if [ -d "$CLUSTER_NAME" ]
then
  echo "The directory $CLUSTER_NAME already exists."
  echo "Are you sure you don't have a running cluster?"
  echo "Manually delete the directory and then rerun this script."
  echo "Exiting. Cluster not created."
  exit 1
fi

mkdir $CLUSTER_NAME
cp $CONFIG_FILE $CLUSTER_NAME/install-config.yaml

# Corporate accounts are probably insufficient to deploy necessary
# resources and register domain name.
# A separate AWS CLI profile may be required to create installer-provisioned resources.
# Security credentials are created in the AWS console (User > Security Credentials > Access Keys)
# and then downloaded and stored in /Users/<current-user>/.aws/credentials.
# The profile can then be specified in as an env variable, or in the command lines.
# e.g. --profile myProfileName

export AWS_PROFILE=personal

# Deploy the OKD cluster
openshift-install create cluster --dir $CLUSTER_NAME --log-level=info

echo
cp mycluster1/auth/kubeconfig $HOME/.kube/config
echo "Copied cluster config to $HOME/.kube.config so kubectl/oc can connect."
# Alternatively, execute "export KUBECONFIG=$CLUSTER_NAME/auth/kubeconfig"
# But that gets cumbersome if you have multiple windows open.

echo "Proceed with smoke test."
echo

