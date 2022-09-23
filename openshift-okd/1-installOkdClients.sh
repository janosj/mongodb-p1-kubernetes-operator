# OKD releases can be found at https://github.com/okd-project/okd/releases
# Download site is in the docs (Installation Process):
# https://docs.okd.io/4.9/architecture/architecture-installation.html#installation-process_architecture-installation

# Download both the installer (openshift-install) and the client tools (oc and kubectl).

OKD_CLIENT_URL=https://github.com/okd-project/okd/releases/download/4.11.0-0.okd-2022-08-20-022919/openshift-client-mac-4.11.0-0.okd-2022-08-20-022919.tar.gz

OKD_INSTALLER_URL=https://github.com/okd-project/okd/releases/download/4.11.0-0.okd-2022-08-20-022919/openshift-install-mac-4.11.0-0.okd-2022-08-20-022919.tar.gz

# Create temporary working space.
TMP_DOWNLOAD_DIR=tmp-OKD-download
if [ -d "$TMP_DOWNLOAD_DIR" ]
then
  echo "Removing old tmp directory."
  rm -rf $TMP_DOWNLOAD_DIR
fi
currentWorkingDir=$(pwd)
mkdir $TMP_DOWNLOAD_DIR
cd $TMP_DOWNLOAD_DIR


echo "Step 1: Install OKD client tools (oc and kubectl)."
echo

echo "Checking for existing oc client..."
if command -v oc &> /dev/null
then
    echo "oc client already installed:"
    oc version
else
  echo "oc client not found locally."
fi

echo
echo "Checking for existing kubectl client..."
if command -v kubectl &> /dev/null
then
    echo "kubectl client already installed:"
    kubectl version
else
    echo "kubectl not found locally."
fi

echo
read -p "Download and install OKD client (oc and kubectl)? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Client install cancelled."
else
  echo "Downloading OKD Client..."
  curl -L -o okdClient.tar.gz $OKD_CLIENT_URL
  echo "Extracting..."
  tar -xvf okdClient.tar.gz
  mv kubectl oc /usr/local/bin
  echo "Moved oc and kubectl binaries to /usr/local/bin."
  echo "OKD client install complete, you may now use either oc or kubectl."
fi

echo
echo "Step 2: Install OKD installer."
echo

echo "Checking for existing install..."
if command -v openshift-install &> /dev/null
then
    echo "openshift-install already installed:"
    openshift-install version
    read -p "Download and install OKD installer (openshift-install)? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
      echo "Installation of OKD Installer cancelled."
      exit 1
    fi
else
  echo "OKD Installer not found locally."
fi

echo "Downloading OKD Installer..."
curl -L -o okdInstaller.tar.gz $OKD_INSTALLER_URL
echo "Extracting..."
tar -xvf okdInstaller.tar.gz
mv openshift-install /usr/local/bin
echo "Moved openshift-install to /usr/local/bin."
echo "OKD Installer installation complete."

echo
echo "OKD Client Tools installation complete."
echo

# Cleanup
cd $currentWorkingDir
rm -rf $TMP_DOWNLOAD_DIR

