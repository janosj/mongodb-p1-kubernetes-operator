echo
echo Deploying MongoDB as client container...

kubectl apply -f ./jj-mongodb-client.yaml --namespace=mongodb

echo
echo VERIFY:
#kubectl get mdb jj-mongo-client -n mongodb -o yaml
kubectl get mdb jj-mongo-client -n mongodb -w

