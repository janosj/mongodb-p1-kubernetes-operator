# Deploys a basic test cluster.
# For more advanced configuration, see the docs, starting here:
# https://www.mongodb.com/docs/atlas/reference/atlas-operator/atlascluster-custom-resource/#configuration-example


cat <<EOF | kubectl apply -f -
apiVersion: atlas.mongodb.com/v1
kind: AtlasCluster
metadata:
  name: demo-atlas-cluster
spec:
  projectRef:
    name: demo-atlas-project
  clusterSpec:
    name: "DEMO-K8s-Atlas-Cluster"
    providerSettings:
      instanceSizeName: M10
      providerName: AWS
      regionName: US_EAST_1
EOF

# Verify
# This will show the deployment, but not whether the cluster is ready
kubectl get AtlasCluster --all-namespaces

echo
echo "For complete status information, look at the Atlas GUI."

echo
echo "Or, use json output to view status conditions:"
echo "kubectl get AtlasCluster demo-atlas-cluster -o json"

echo
echo "Or, specify a JSONPath query to access the specific status field."
echo "(Inspect script for details.)"


# The output of this query is either true or false, but note that the output sometimes gets
# prefixed to the command prompt, making it seem like the query returned empty.

# kubectl get AtlasCluster demo-atlas-cluster -o=jsonpath='{.status.conditions[?(@.type=="ClusterReady")].status}'


