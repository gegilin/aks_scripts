#!/bin/sh
# Can be added for authentication only  once
# echo `az account set --subscription 5f1a7952-1f11-41a0-b6bf-7a8b70db10b2`
# echo `az aks get-credentials --resource-group adp-dev-uksouth --name adp-dev-uksouth`
timeout=10
namespace='services-uksouth'
#namespace='geneva'
while true
do
   echo "Going to kill pods $(date)"
   kubectl -n $namespace get pods --field-selector=status.phase=Running -l 'app.kubernetes.io/name in (core-dms)' | awk '{print $1}' > current_pods.txt
   while IFS= read -r current_pod
   do
   if [ $current_pod != "NAME" ]; then
   echo "Going to kill $current_pod"
      kubectl delete -n $namespace pod $current_pod --force
   else
    echo "Skipping"
   fi    
   done < "current_pods.txt"
   echo "After killing pods $(date)"
   sleep $timeout
done
