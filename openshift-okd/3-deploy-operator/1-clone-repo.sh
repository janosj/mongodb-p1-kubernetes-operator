source env.conf

# Clones a versioned branch of the MongoDB Kubernetes Operator repo.
# The full repo is here: https://github.com/mongodb/mongodb-enterprise-kubernetes
# We want the specific branch that matches the version of the Operator we are deploying.
# Pulling even the entire branch is still somewhat overkill, as it's only the 
# crds and mongodb-enterprise-openshift yaml files that are actually needed. 

if [ -d "$REPO_DIR" ]
then
  echo "Removing old MDB Kubernetes repo."
  rm -rf $REPO_DIR
fi

# See here:
# https://www.freecodecamp.org/news/git-clone-branch-how-to-clone-a-specific-branch/

git clone --branch $REPO_BRANCH --single-branch https://github.com/mongodb/mongodb-enterprise-kubernetes.git $REPO_DIR

#rm -rf $REPO_DIR/.git
#rm -rf $REPO_DIR/.github

echo
echo "Repo cloned to $REPO_DIR."
echo


