if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo
echo *****
echo INSTALLING DOCKER...
echo *****
echo


# Fixes error: docker requires container-selinux
sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm


# Remaining original setup steps come from here:
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

# Install Docker CE
## Set up the repository
### Install required packages.
yum install -y yum-utils device-mapper-persistent-data lvm2

### Add Docker repository.
yum-config-manager --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

## As of 5-Nov-2020 that repo has some sort of bug. 
## See here: https://forums.docker.com/t/docker-ce-stable-x86-64-repo-not-available-https-error-404-not-found-https-download-docker-com-linux-centos-7server-x86-64-stable-repodata-repomd-xml/98965/5
## Workaround:
## Edit /etc/yum.repos.d/docker-ce.repo
## Change $releasever to 7
sed -i 's/\$releasever/7/g' /etc/yum.repos.d/docker-ce.repo

## Install Docker CE.
yum update -y && yum install -y \
  containerd.io-1.2.13 \
  docker-ce-19.03.8 \
  docker-ce-cli-19.03.8

## Create /etc/docker directory.
mkdir /etc/docker

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

echo Restarting Docker...
systemctl daemon-reload
systemctl restart docker

# Enabling auto restart...
sudo chkconfig docker on
# This seems to have changed. Try this:
# sudo systemctl enable docker

