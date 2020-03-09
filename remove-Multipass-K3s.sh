kubectl delete pods --all --grace-period=0 --force

multipass.exe exec node3 -- bash -c "/usr/local/bin/k3s-agent-uninstall.sh"
multipass.exe exec node2 -- bash -c "/usr/local/bin/k3s-agent-uninstall.sh"
multipass.exe exec node1 -- bash -c "/usr/local/bin/k3s-uninstall.sh"

multipass.exe stop node1 node2 node3
multipass.exe delete node1 node2 node3
multipass.exe purge