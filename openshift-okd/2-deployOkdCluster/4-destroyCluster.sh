source env.conf

echo "This will destroy the cluster $CLUSTER_NAME"
read -p "Are you sure you want to proceed? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancelled."
    exit 1
fi

export AWS_PROFILE=personal

openshift-install destroy cluster --dir $CLUSTER_NAME --log-level info

echo "Cluster destroyed? Verify on AWS. Once confirmed, "
echo "completely remove the cluster directory ($CLUSTER_NAME)."

