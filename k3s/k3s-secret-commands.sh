#set PAT into K3s (create or update)
kubectl create secret generic azp --from-literal=AZP_TOKEN=$AZP_TOKEN \
 --from-literal=AZP_URL=https://dev.azure.com/totosan --dry-run -o yaml | kubectl apply -f -

#set ACR creds into K3s
kubectl create secret docker-registry acr --docker-server=iotcontainertt.azurecr.io --docker-username=IoTContainerTT \
--docker-password=$DOCKER_PASSWORD --docker-email=iotcontainertt@azurecr.io --dry-run -o yaml \
| kubectl apply -f -