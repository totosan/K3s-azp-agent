# Running Azure DevOps Build Agent in kubernetes cluster (K3S)

## Description ##
This repo demonstrates the possibility to run an Azure DevOps build agent in a K3s cluster from Rancher.
From architecture view a Multipass host with three VMs (Ubuntu) is used to keep a K3s cluster running. with the use of Multipass, you can run this either on Linux, MacOS or Windows (it has to be an x86_64 arc.).

## Setup ##
I used a Windows 10 with [Multipass](https://multipass.run) installed.
Additionally, I activated Windows Subsystem for Linux (ver.1).
### 1. Docker image for build agent ###
You need a container registry, where you have user and password for. I used Azure Container Registry.
I used a docker image from this [Microsoft docs page](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux) and modified it a little bit.   
Use a Powershell and build the docker image. 
```powershell
> docker build --rm -f "build-agent.dockerfile" -t <private registry>.azurecr.io/k3spipelineagent:0.0.1 "."
> docker push <private registry>.azurecr.io/k3spipelineagent:0.0.1
```
### 2. Setup agent pool access for selfhosted agent ###

Please read this [Microsoft doc](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops) for setting up a PAT (Personal access token)

## Steps to reporduce ##
- open WSL   
   ```bash
   > git clone https://github.com/totosan/K3s-azp-agent.git
   > cd K3s-azp-agent
   > bash ./create-Multipass.K3s.sh
   ```
   This creates 3 VMs with Ubuntu installed.   
   Ubuntu VM `node1` is k3s server, `node2` and `node3` are the      additional joined worker.

- the output contains an "**export**" Statement for **KUBECONFIG**; copy and paste and run
- create a **.env** file in **k3s** folder; either with VSCode: `code .`, `nano .env` or what favorit editor you like to.
- add two environment variables into the file  
    ```
    AZP_TOKEN=<your personal access token from Azure DevOps>
    DOCKER_PASSWORD=<your private docker registry password>
    ```
- run
    ```bash
    > bash ./k3s/enable-secrets.sh
    ```
    You should modify the **./k3s/azp_deployment.yaml** according to your setting (Azrue DevOps Agent Pool Name, Azre Container Registry,...)
    ```
    > kubectl apply -f k3s/azp_deployment.yml
    ```
- you can run to doublecheck the deployment:
    ```bash
    kubectl rollout status deployment/azp-agent
    ```
- after the rollout has succeeded have a look into the logs:
    ```
    kubectl logs -lapp=azp-agent -f
    ```
- the option `-f` means "follow" and keeps the log stream open. With that you can run a build and see, whats going on with the build agent.