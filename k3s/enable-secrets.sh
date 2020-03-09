source k3s/.env
export $(cut -d= -f1 k3s/.env)
envsubst < k3s/k3s-secret-commands.sh | bash -