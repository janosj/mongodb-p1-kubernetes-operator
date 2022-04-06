#!/bin/bash

echo 
echo "About to deploy Kubernetes Dashboard."
echo "The dashboard has to be deployed on the Kubernetes cluster"
echo "but accessed via localhost on your desktop using kubectl proxy."
echo "Kubectl has to be installed on your desktop and configured"
echo "to connect to the cluster."
echo "If it isn't already installed, install kubectl on your Mac:"
echo "  brew install kubectl"
echo
echo "Configure kubectl to connect to your remote K8s cluster"
echo "For example:"
echo " scp -i $HOME/Keys/<aws-key>.pem ec2-user@k81:./.kube/config $HOME/.kube/config"
echo
echo "The server info may be an internal IP address, which also maps to the cert."
echo "So, ensure that the internal hostname is present in your /etc/hosts file"
echo "and swap out the IP address for the internal hostname in the .kube/config file."
echo "Port 6443 must be open."
echo 

echo "Copy the K8s config file from the cluster to local now."
echo "For example:"
echo " scp -i $HOME/Keys/<aws-key>.pem ec2-user@k81:./.kube/config $HOME/.kube/config"
echo "Test connectivity as follows (from your Mac):"
echo "  kubectl cluster-info"

echo
read -n 1 -s -r -p "Press any key to proceed."
echo
echo

echo "Deploying Kubernetes dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml

echo
echo "Creating dashboard user..."
kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
kubectl get secrets
kubectl describe secret $(kubectl get secret | grep dashboard-admin | awk '{print $1}')

echo 
echo "Deployment complete."
echo "To generate an access token, execute the following:"
echo "  kubectl describe secret $(kubectl get secret | grep dashboard-admin | awk '{print $1}')"
echo 
echo "To start the local proxy server:"
echo "  kubectl proxy"
echo 
echo "Access the dashboard at:"
echo "  http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
echo

