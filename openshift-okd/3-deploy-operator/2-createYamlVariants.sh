echo "This script takes the mongodb-enterprise-openshift.yaml file from the repo"
echo "and modifies it for 3 specific purposes:"
echo "1. Adds a Pull Secret to pull containers from the Red Hat repo (per the MongoDB documentation)."
echo "2. Redirects to a test repo, for testing the Platform One containers prior to submission."
echo "3. Redirects to Iron Bank, for testing the submitted Iron Bank containers."
echo

source env.conf

FILENAME_ORIGINAL=mongodb-enterprise-openshift.0.original.yaml
FILENAME_OPENSHIFT_MODS=mongodb-enterprise-openshift.1.pullSecret.yaml
FILENAME_PLATFORM1_TEST=mongodb-enterprise-openshift.2.p1-quaytest.yaml
FILENAME_PLATFORM1=mongodb-enterprise-openshift.3.p1-ironbank.yaml

PLATFORM1_REPO=registry1.dso.mil/ironbank/mongodb/mongodb-enterprise

read -p "What version of the agent do you want to use? [$AGENTDEFAULT] " agentver
AGENTVER=${agentver:-$AGENTDEFAULT}
echo "Using agent Version: $AGENTVER"

# Create directory for yaml files
if [ -d "$YAML_DIR" ]
then
  echo "Removing existing YAML directory"
  rm -rf $YAML_DIR
fi
mkdir $YAML_DIR

echo "Creating YAML variants in $YAML_DIR/"

# Copy original yaml file from downloaded MongoDB repo.
cp $REPO_DIR/mongodb-enterprise-openshift.yaml $YAML_DIR/$FILENAME_ORIGINAL
echo "Original YAML copied from MDB repo to $YAML_DIR/ (don't use)"
echo


# Modify file for Openshift. Uses standard MongoDB container images from registry.connect.redhat.com.
# Implements a manual step that's in the directions:
# https://www.mongodb.com/docs/kubernetes-operator/master/openshift-quick-start/#install-the-k8s-op-full
# Pulling images from the registry.connect.redhat.com repository requires authentication.
# You have to manually create a ServiceAccount, and then identify the pull secret here.
# The secret itself will be created later using a separate script.

# Sed note: ^ denotes first character in the line 
# (so 'kind: ServiceAccount' can't have any characters in front of it, a necessary criteria)
sed 's/^kind: ServiceAccount/kind: ServiceAccount\nimagePullSecrets:               # ADDED FOR OPENSHIFT\n - name: openshift-pull-secret  # ADDED FOR OPENSHIFT/g' $YAML_DIR/$FILENAME_ORIGINAL > $YAML_DIR/$FILENAME_OPENSHIFT_MODS

echo "1. File $FILENAME_OPENSHIFT_MODS created,"
echo "   Updated to include required Pull Secret for Red Hat repo."
echo "   3rd-party products are pulled from registry.connect.redhat.com, which requires authentication."
echo "   The pull secret itself has to be manually created and then deployed to OKD (that's next)."
echo "   The pull secret is tied to a Red Hat service account, which has to be created."
echo 


# Modify file for local testing.
# Used in conjunction with a set of container images that have been modified 
# for Platform One and pushed to a public test repo on quay.io.

# We don't need any pull secrets here, if the containers on quay are made public,
# So start with the original:
cp $YAML_DIR/$FILENAME_ORIGINAL $YAML_DIR/$FILENAME_PLATFORM1_TEST

# Replace mongo repo (quay.io/mongodb) with test repo:
# sed notes: Use double quotes to expand variable TEST_QUAY_REPO, and
#            Use '|' instead of '/' to avoid having to escape forward slashes.
sed -i '' "s|quay.io/mongodb|quay.io/$TEST_QUAY_REPO|g" $YAML_DIR/$FILENAME_PLATFORM1_TEST

# As of Operator 1.17.2, all the images were renamed to *-ubi.
# This is not the case in Platform One, so that has to be stripped out everywhere.
sed -i '' "s|-ubi||g" $YAML_DIR/$FILENAME_PLATFORM1_TEST

# The container names are different on Quay than they are on Red Hat
# (Looks like this was fixed in 1.17.2 when things were renamed to *-ubi)
#sed -i '' "s|mongodb/enterprise-operator|mongodb/mongodb-enterprise-operator|g" $YAML_DIR/$FILENAME_PLATFORM1_TEST
#sed -i '' "s|mongodb/enterprise-database|mongodb/mongodb-enterprise-database|g" $YAML_DIR/$FILENAME_PLATFORM1_TEST

# (Looks like this was fixed in 1.17.2)
# Replace the following (the agent is on quay for some reason):
#  registry.connect.redhat.com/mongodb   with   quay.io/TEST_QUAY_REPO
# sed -i '' "s|registry.connect.redhat.com/mongodb|quay.io/$TEST_QUAY_REPO|g" $YAML_DIR/$FILENAME_PLATFORM1_TEST

# The container versions should match what's in the enterprise-database.yaml file.
# But the agent won't, because it was selected to match the Ops Manager release.
sed -i '' "s|mongodb-agent.*|mongodb-agent:$AGENTVER\"|" $YAML_DIR/$FILENAME_PLATFORM1_TEST

echo "2. File $FILENAME_PLATFORM1_TEST created"
echo "   to test Iron Bank containers prior to submission."
echo "   Configured to use the quay.io/$TEST_QUAY_REPO repo."
echo "   References to *-ubi (introduced in 1.17) have been removed, to mirror P1 container naming conventions."
echo "   The agent version was updated to $AGENTVER."
echo


# Modify for Platform One.
# Easiest to start with the file created above (the Platform One test file)
# because it already has some required corrections. 
cp $YAML_DIR/$FILENAME_PLATFORM1_TEST $YAML_DIR/$FILENAME_PLATFORM1

# Swap the registry from quay.io/TEST_QUAY_REPO to registry1.dso.mil/ironbank/mongodb
# Using '|' instead of '/' avoids escape errors with forward slashes.
sed -i '' "s|quay.io/$TEST_QUAY_REPO|$PLATFORM1_REPO|g" $YAML_DIR/$FILENAME_PLATFORM1

# Registry1 (Iron Bank) requires authentication.
# Add pull secret. Same as for RedHat, but without the service account.
# Sed note: ^ denotes first character in the line
# (so 'kind: ServiceAccount' can't have any characters in front of it, a necessary criteria).
sed -i '' 's/^kind: ServiceAccount/kind: ServiceAccount\nimagePullSecrets:               # ADDED FOR IRON BANK\n - name: registry1-credentials  # ADDED FOR IRON BANK/g' $YAML_DIR/$FILENAME_PLATFORM1

echo "3. File $FILENAME_PLATFORM1 created"
echo "   to test submitted Iron Bank containers."
echo "   Based on file from (2) with all corrected image names and versions."
echo "   Configured to use $PLATFORM1_REPO repo."
echo "   Updated to include required Pull Secret for Iron Bank."
echo "   The pull secret itself has to be manually created and then deployed to OKD (that's next)."
echo
