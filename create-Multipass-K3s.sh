for node in node1 node2 node3;do
  multipass.exe launch -n $node
done

# Init cluster on node1
multipass.exe exec node1 -- bash -c "curl -sfL https://get.k3s.io | sh -"

# Get node1's IP
IP=$(multipass.exe info node1 | grep IPv4 | awk -v RS="\r\n" '{print $2}')
echo "$IP"

# Get Token used to join nodes
TOKEN=$(multipass.exe exec node1 sudo cat /var/lib/rancher/k3s/server/node-token)
echo "$TOKEN"

# Join node2
multipass.exe exec node2 -- \
bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$IP:6443\" K3S_TOKEN=\"$TOKEN\" sh -"

# Join node3
multipass.exe exec node3 -- \
bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$IP:6443\" K3S_TOKEN=\"$TOKEN\" sh -"

# Get cluster's configuration
multipass.exe exec node1 sudo cat /etc/rancher/k3s/k3s.yaml > $PWD/k3s.yaml

# Set node1's external IP in the configuration file
find "$PWD/k3s.yaml" -type f -exec sed -i "s/127.0.0.1/$IP/" {} +

# We'r all set
echo
echo "K3s cluster is ready !"
echo
echo "Run the following command to set the current context:"
echo "$ export KUBECONFIG=$PWD/k3s.yaml"
echo
echo "Powershell:"
echo "> $env:KUBECONFIG=$(Get-ChildItem k3s.yaml | %{ $_.FullName})"
echo
echo "and start to use the cluster:"
echo  "$ kubectl get nodes"
echo
