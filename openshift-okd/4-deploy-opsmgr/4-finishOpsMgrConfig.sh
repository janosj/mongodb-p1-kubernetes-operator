# This script provides instructions to manually access the Ops Manager UI, 
# create a new Organization, and create an API Key.
# It then updates various script files with those settings.

# Note that some manual steps were avoided by setting "ignoreInitialUiSetup" 
# to "true" and supplying the mandatory Ops Manager settings.
# But the remaining manual steps are still mandatory. They are documented as 
# Prerequisites to creating credential for the Kubernetes Operator, here:
# https://docs.mongodb.com/kubernetes-operator/v1.14/tutorial/create-operator-credentials/#prerequisites

echo
kubectl get svc ops-manager-svc-ext -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n mongodb

echo
echo "Access the Ops Manager UI at the URL listed above."
echo "The default port for Ops Manager (using a load balancer) is 8080."
# Had we used a Node Port, you would connect to any cluster node on the configured Node Port.
echo "The user and password was specified when the AdminUserSecret was created."

echo
echo "In Ops Manager, create a new Organization:"
echo "  - Access your user profile in the upper right corner"
echo "  - select Organizations"
echo "  - click Create New Organization"
# the admin user becomes an Organization Owner.
echo
echo "Enter the Ops Manager URL: (just cut and paste from above, without the port)"
read OMURL
echo
echo "Enter the new Organization ID (under Organization Settings): "
read ORGID
echo

echo "export OPSMGR_URL=http://$OMURL:8080" > ../5-deploy-mdb-resources/opsmgr.settings.notCommitted
echo "export OPSMGR_ORG=$ORGID" >> ../5-deploy-mdb-resources/opsmgr.settings.notCommitted

echo "../deploy-mdb-resources/opsmgr.settings.notCommitted has been updated:"
echo "  - Ops Manager URL: $OMURL"
echo "  - Organization ID: $ORGID"
echo "*** Note: This was configured for HTTP on Port 8080. Modify if using SSL. ***"
echo

echo "Now create an API Key (Access Manager > API Keys)."
echo "For permissions, select Organization Owner and clear all others."
echo "Add a whitelist entry to allow access from the K8s worder nodes."
echo "The internal CIDR range in use by the OKD cluster is not obvious."
echo "Using the 'Use current IP address' option seems to work,"
echo "so set it to X.Y.0.0/16, where X.Y. is provided by that value."
echo "This script has some more notes about it."
echo

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
# So I relied on the error messages that show up in the logs after I try to deploy a MongoDB resource:
#   kubectl logs mongodb-enterprise-operator-<identifier>
# Note that 0.0.0.0/0 is not allowed.


echo "Enter the public API Key: "
read PUBLICKEY
echo
echo "Enter the private API Key: "
read PRIVATEKEY
echo

kubectl -n mongodb create secret generic opsmgr-credentials --from-literal="publicKey=$PUBLICKEY" --from-literal="privateKey=$PRIVATEKEY"

echo
echo Verify:
kubectl describe secrets/opsmgr-credentials -n mongodb
echo

echo "You may now proceed with deploying MDB resources."
echo "Make sure you Added an Access List Entry to the API Key."
echo

