if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi
 
kubeadm init --pod-network-cidr=192.168.0.0/16

#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
mkdir ~ec2-user/.kube
chown ec2-user:ec2-user ~ec2-user/.kube
cp /etc/kubernetes/admin.conf ~ec2-user/.kube/config
chown ec2-user:ec2-user ~ec2-user/.kube/config

echo
echo Installing Calico pod network plugin...
# Needs to run as ec2-user
su -c "kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml" ec2-user

echo
echo Confirming everything is running...
# Needs to run as ec2-user
su -c "kubectl get pods --all-namespaces" ec2-user

echo 
echo ***
echo *** NOTE: Look at the previous output to retrieve the JOIN COMMAND to add worker nodes to the cluster.
echo

