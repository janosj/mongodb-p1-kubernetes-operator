# Deploy Atlas Kubernetes Operator:

# As of May 27, 2022, this next command is a bit of a moving target.
# The command I used back in April 2022:
# kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-atlas-kubernetes/main/deploy/all-in-one.yaml
# Note that's using the main branch.
# The Quick Start Guide as of May 27 says to use this:
# https://raw.githubusercontent.com/mongodb/mongodb-atlas-kubernetes/<version>/deploy/all-in-one.yaml
# substituting the correct version. But "0.8.0" will not work, it looks like it should be "v0.8.0".
# Do not pull from main anymore - doing so will appear to work but then the cluster won't deploy.
# I'm currently using the old all-in-one.yaml file I had downloaded back in April.
# The docs are being updated to be correct.
# Apparently 1.0.0 (GA?) was just released 4 days ago (May 23 2022?).

# For now:
kubectl apply -f all-in-one.notCommitted.yaml


# Verify
# Shows the operator deployed (by default) into the mongodb-atlas-system namespace.
kubectl get pods --all-namespaces -w

