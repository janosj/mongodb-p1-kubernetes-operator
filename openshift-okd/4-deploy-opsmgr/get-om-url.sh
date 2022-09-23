kubectl get svc ops-manager-svc-ext -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n mongodb

echo
echo "(probably http, probably port 8080)"



