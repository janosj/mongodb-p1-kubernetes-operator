if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

./1-install-prereqs.sh

./2-install-docker.sh

./3-install-k8s.sh

