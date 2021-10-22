if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo
echo *****
echo INSTALLING PREREQUISITES...
echo *****
echo

# Source is here: 
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic

# kubeadm init fails if you don't do this.

lsmod | grep br_netfilter

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

