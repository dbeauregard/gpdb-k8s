# gpdb-k8s
Instructions to run Greenplum Database (GPDB) in Kubernetes (K8s)

## ARM-based Mac/OSX Setup
### Prerequisits
1. Docker (client) Installed (e.g., Homebrew) (podman *should* also work)
```shell
brew install Docker
```
2. Fully shutdown docker/podman; it will conflict if running but the client libraries must still be installed in the above step (e.g., ‘Quit Docker Desktop’ from the menu bar).
3. kubectl installed (e.g., Homebrew)
```shell
brew install kubectl
```
4. Install Colima & QEMU: (e.g., Homebrew)
```shell
brew install qemu colima lima-additional-guestagents
```
5. Install Helm (e.g., Homebrew)
```shell
brew install helm
```

### Export Credentials
WIP
- JFROG_USER=
- JFROG_PASSWORD=
- DOCKER_URL=

### Run K8s in Colima
1. Start Colima
```shell
‘colima start --arch x86_64 --kubernetes --cpu 4 --memory 4’ 
```
   - I suggest using --cpu 4 and –memory 4 to use 4 cores and 4GB or RAM with Colima but you can adjust as needed
   b. If this fails make sure you have ‘lima-additional-guestagents’ installed and docker is NOT actively running on your laptop (must be installed, but not running)
   - Validate K8s is up and running (e.g., ‘kubectl get nodes’)
2. Validate K8s is up and running 
```shell
kubectl get nodes
```

### Deploy GPDB Operator
https://techdocs.broadcom.com/us/en/vmware-tanzu/data-solutions/tanzu-greenplum-k8s/1-0/tgp-on-k8s/04-installation.html

### Deploy GPDB Cluster

### Deploy GPCC