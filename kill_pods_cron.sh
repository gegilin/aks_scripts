#!/bin/sh
timeout=10
namespace='services-uksouth'
echo "Going to kill pods $(date)"
kubectl -n $namespace get pods --field-selector=status.phase=Running -l 'app.kubernetes.io/name in (core-dms)' --no-headers=true | awk '{print $1}' > current_pods.txt
while IFS= read -r current_pod
do
 echo "Going to kill $current_pod"
 kubectl delete -n $namespace pod $current_pod --force
done < "current_pods.txt"
echo "After killing pods $(date)"
