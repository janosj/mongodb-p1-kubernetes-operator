kubectl describe secret $(kubectl get secret | grep dashboard-admin | awk '{print $1}')

