# This script provides instructions to manually access the Ops Manager UI, 
# create a new Organization, and create an API Key.
# It then updates various script files with those settings.

# Note that some manual steps were avoided by setting "ignoreInitialUiSetup" 
# to "true" and supplying the mandatory Ops Manager settings.
# But the remaining manual steps are still mandatory. They are documented as 
# Prerequisites to creating credential for the Kubernetes Operator, here:
# https://docs.mongodb.com/kubernetes-operator/v1.14/tutorial/create-operator-credentials/#prerequisites

source env.conf

echo
echo "The Ops Manager UI is accessible at the following URL:"
kubectl get svc ops-manager-svc-ext -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n mongodb

echo
echo "Enter the Ops Manager URL: (just cut and paste from above, no protocol or port)"
read OMURL

echo
echo "Access the Ops Manager UI at http://$OMURL:8080"
echo "This script assumes http (not https), and the default"
echo "port for Ops Manager (using a load balancer) is 8080."
# Had we used a Node Port, you would connect to any cluster node on the configured Node Port.
echo "The user and password was specified when the AdminUserSecret was created."

echo
echo "In Ops Manager, create a new Organization:"
echo "  - Access your user profile in the upper right corner"
echo "  - select Organizations"
echo "  - click Create an Organization"
echo "  - Use any name and accept the remaining defaults."
# the admin user becomes an Organization Owner.
echo
echo "Access the new Org ID (under Organization Settings) and enter it here: "
read ORGID

echo "export OPSMGR_URL=http://$OMURL:8080" > $OPS_MGR_SETTINGS_FILE
echo "export OPSMGR_ORG=$ORGID" >> $OPS_MGR_SETTINGS_FILE

echo
echo "The $OPS_MGR_SETTINGS_FILE has been updated with the OM URL and new Org ID:"
echo "  - Ops Manager URL: $OMURL"
echo "  - Organization ID: $ORGID"
echo "These settings will be used when creating database resources."
echo

echo "Now create an API Key (Access Manager > Organization Access > API Keys)."
echo "For permissions, select Organization Owner and clear all others."

echo
echo "Enter the public API Key: "
read PUBLICKEY
echo
echo "Enter the private API Key: "
read PRIVATEKEY
echo

echo "Creating secret with Ops Manager credentials..."
kubectl -n mongodb create secret generic opsmgr-credentials --from-literal="publicKey=$PUBLICKEY" --from-literal="privateKey=$PRIVATEKEY"

echo
echo Verify:
kubectl describe secrets/opsmgr-credentials -n mongodb
echo

echo "Add a whitelist entry to allow access from the K8s worder nodes."
echo "The internal CIDR range in use by the OKD cluster is not obvious."
echo "Using the 'Use current IP address' option seems to work,"
echo "so set it to X.0.0.0/8, where X is provided by that value."
echo "This script has some more notes about it."

# How do you know the pod CIDR range? Depends on the networking.
# Remember, Kubernetes does not come with a default networking solution.
# Instead, their Container Network Interface (CNI) allows network providers
# to build their own SDR (software defined networking) solutions.
# They all work differently.

# Our docs (here: https://github.com/mongodb/mongodb-enterprise-kubernetes) say
# you can run the following command: "kubectl cluster-info dump | grep -m 1 cluster-cidr".
# That might work on vanilla Kubernetes (where it was 192.0.0.0/8).
# It doesn't work with OKD's default networking.
# Nor did the network config defined in the cluster config file match the actual IP addresses in use.
# The config file revealed that the cluster was set to use OVN-Kubernetes.
# I didn't find any way to determine the proper pod CIDR range with this networking plug-in.
# You might see a source address identified in the error messages within the logs 
# after you deploy a MongoDB resource without having the access list correctly configured.
# Note that 0.0.0.0/0 is not allowed.

echo
read -n 1 -s -r -p "Add the Access List Entry, then press any key to continue."

echo
echo
echo "Ops Manager configuration complete! Scripts updated with new settings."
echo "You may now proceed with deploying MDB resources."
echo

