source env.conf

MDB_URI=mongodb://$RS_NAME-0.$SERVICE_NAME.mongodb.svc.cluster.local:27017,$RS_NAME-1.$SERVICE_NAME.mongodb.svc.cluster.local:27017,$RS_NAME-2.$SERVICE_NAME.mongodb.svc.cluster.local:27017/?replicaSet=$RS_NAME

echo
echo "Connects to a Mongo client container (assuming you "
echo "deployed one and named it 'mdb-client'), allowing you "
echo "to verify that the form data is making it to the target database."
echo
echo "The DB connect string is available from Ops Manager,"
echo "but it is determined by the database and service names "
echo "specified in the deployment yaml files."
echo
echo "The following URL is derived from this project's RS settings. Use mongosh instead of mongo:"
echo "mongosh '$MDB_URI'"
echo

kubectl exec -it -n mongodb mdb-client -- /bin/bash
