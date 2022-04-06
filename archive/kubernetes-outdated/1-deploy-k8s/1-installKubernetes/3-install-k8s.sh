if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

basearch=x86_64

echo
echo *****
echo INSTALLING KUBERNETES...
echo *****
echo


# Remaining original setup steps come from here:
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

