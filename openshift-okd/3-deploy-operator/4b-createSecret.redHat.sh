source env.conf

SECRET_FILE=4a-manual-secret-steps/pullSecret.openshift.yaml.notCommitted

if ! [ -f "$SECRET_FILE" ]; then
   echo "Secret file not found. Expecting to find it here:"
   echo "$SECRET_FILE"
   echo "Perform the manual Red Hat steps, and then rerun this script."
   echo "Operation canceled."
   exit
fi

oc apply -f $SECRET_FILE -n mongodb

