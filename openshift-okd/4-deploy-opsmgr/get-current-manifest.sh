# Deploying the latest version of MongoDB, you may get an error that
# the specified version is unavailable. 
# First, check the db-binaries container to ensure that it's there.
# If the version is present, the problem is likely that Ops Manager's 
# version-manifest needs to be updated. 

# To inspect the current version of the manifest being used by Ops Manager:
curl --include --header "Accept: application/json" --request GET "http://<ops-manager-url>:8080/api/public/v1.0/unauth/versionManifest?pretty=true" -o current_manifest.notCommitted.json


# If connected to the Internet, the version manifest can be updated within the 
# Ops Manager UI (the admin tab).
# In disconnected environments, the manifest has to be manually downloaded, 
# transferred, and then uploaded.

