source env.conf

if [ -f "$CONFIG_FILE" ]; then
   echo "$CONFIG_FILE already exists."
   read -p "Do you want to rebuild and replace it? (y/n) " -n 1 -r
   echo
   if [[ ! $REPLY =~ ^[Yy]$ ]]
   then
     echo "Operation canceled."
     exit
   else 
     CURRENT_TIME=$(date '+%d%b%Y-%H-%M-%S')
     BACKUP_FILE="$CONFIG_FILE.$CURRENT_TIME"
     cp $CONFIG_FILE $BACKUP_FILE
   fi
fi

TMP_DIR=tmp-okd
if [ -d "$TMP_DIR" ]
then
  rm -rf $TMP_DIR
fi

echo
echo "A cluster config file isn't necessary, but it provides"
echo "a means to permanently store the requested information"
echo "and also allows you to provide additional customizations"
echo "that aren't available with the default installation."

# See here for more information:
# https://docs.okd.io/latest/installing/installing_aws/installing-aws-customizations.html

# Required information.
echo
echo "The OKD config utility will prompt you for the following information:"
echo "  - Cloud Platform: aws"
echo "  - Region: Ohio (note there are EIP limits that hinder N. Virginia)"
# AWS account limits are here:
# https://docs.okd.io/4.9/installing/installing_aws/installing-aws-account.html#installation-aws-limits_installing-aws-account
# Note the red box: "to use us-east-1 you must increase the EIP limit"
echo "  - Base Domain: a domain name you control, registered in Route 53"
echo "  - Cluster Name: (this script is using $CLUSTER_NAME)"
echo "  - Pull Secret: obtain from Red Hat - this script contains more info"
echo

# The link to obtain your pull secret is contained in the aws install doc:
# https://docs.openshift.com/container-platform/4.6/installing/installing_aws/installing-aws-default.html
# The actual link is this: https://console.redhat.com/openshift/install/pull-secret
# Sign in using your Red Hat account and click the "Download Pull Secret" button.
# Copy and paste the entire value into the config utility.

# Run the configuration utility.
# This will store the config file in the specified directory,
# which will be populated with additional files during deployment.
# Note that config file will be "consumed" by the installer,
# so the file is preserved further below in this script.
openshift-install create install-config --dir $TMP_DIR

# pasting the pull secret leaves a mess on screen.
# clear is required for readability.
clear

echo "Required customization:"
echo "By default the OKD installer creates 6 EC2 instances,"
echo "3 masters (m5.xlarge instances across multiple AZs), and"
echo "3 workers (m5.large: only 2 cores and 7.5GB RAM, 4.5GB available)."
echo "Those workers are too small - Ops Manager requires a minimum of 5GB memory."
echo "The number of masters can't be modified, but the worker type can be:"
echo "I upgraded them to m5.xlarge to get 4 CPUs and 16 GB RAM."
echo

# Instance types can also be modified post-installation using the AWS EC2 console.
# To reduce costs, one of the master nodes can be shut down without affecting service.
# Kubectl commands become unresponsive if 2 of the 3 master nodes are shut down.

echo "Adding modification to config file..."

# This sed command works on Mac OS. 
# Other solutions required gnu-sed (or something else entirely).
# This crazy sed command replaces the first occurance (compute section only) of:
#   'platform: {}'
# with this:
#   platform:
#     aws:
#       type: m5.xlarge
sed -e '1s/  platform: {}/  platform:\n    aws:\n      type: m5.xlarge/;t' -e '1,/  platform: {}/s//  platform:\n    aws:\n      type: m5.xlarge/' $TMP_DIR/install-config.yaml > $TMP_DIR/sed-out.yaml
mv $TMP_DIR/sed-out.yaml ./$CONFIG_FILE
rm -rf $TMP_DIR

echo
echo "Config file created ($CONFIG_FILE)"
echo
echo "You may now run the installer to deploy your OKD cluster."
echo

