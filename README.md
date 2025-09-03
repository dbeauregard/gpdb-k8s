# GPDB on K8s
Instructions to run Greenplum Database (GPDB) in Kubernetes (K8s).  We will be deploying GPDB to K8s locally on your laptop using the GPDB Operator which, by default, deploys one controller and one segment (as pods/containers).  The GPDB images require an x86_64 architecture.  On ARM based Macs we will be using Colima and QEMU, which provides emulation for ARM.  For Intel based Macs emulation won’t be needed and K8s can be used directly, i.e., via Kind or Minikube (Colima works here too).

## ARM-based Mac/OSX Setup
### Prerequisits
1. Docker (client) Installed (e.g., Homebrew) (podman *'should'* also work)
```shell
brew install Docker
```
2. Fully shutdown Docker/Podman (e.g., `Quit Docker Desktop` from the menu bar). It will conflict if running, but the client libraries must still be installed in the above step.
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
6. Install the psql CLI (e.g., Homebrew)
   - You can install it with Postgres (or if you already have postgres you should already have psql)
   ```shell
   brew install postgresql
   ```
   - Or you can install it standalone via libpq
   ```shell
   brew install libpq
   brew link --force libpq
   ```
---

### Export Your Repository Credentials
1. Login to [support.broadcom.com](http://support.broadcom.com)
2. Select 'My Downloads'
3. Search for Greenplum and Select "VMware Tanzu Greenplum on Kubernetes"
4. Expand (click on the right arrow '>') "VMware Tanzu Greenplum on Kubernetes"
5. Click on the Green Sheild for the release (e.g., "1.0.0")
6. View your Repository Credentials 
7. Export your Credentials
```shell
export GPDB_USER='user.email@company.com'
export GPDB_PASSWORD='****'
```
---

### Run K8s in Colima
1. Start Colima
```shell
colima start --arch x86_64 --kubernetes --cpu 4 --memory 4
```
   - I suggest using --cpu 4 and –memory 4 to use 4 cores and 4GB or RAM with Colima but you can adjust as needed
   b. If this fails make sure you have ‘lima-additional-guestagents’ installed and docker is NOT actively running on your laptop (must be installed, but not running)
   - Validate K8s is up and running (e.g., ‘kubectl get nodes’)
2. Validate K8s is up and running 
```shell
kubectl get nodes
```
---

### Deploy GPDB Operator
[Docs Here](https://techdocs.broadcom.com/us/en/vmware-tanzu/data-solutions/tanzu-greenplum-k8s/1-0/tgp-on-k8s/04-installation.html)

Simple Instructions
1. Create a new namespace
```shell
kubectl create ns gpdb
```
2. Install Cert Manager
```shell
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
```
3. Helm Login
```shell
helm registry login -u $GPDB_USER -p $GPDB_PASSWORD tanzu-greenplum.packages.broadcom.com
```
4. Set Docker Secret
```shell
kubectl create secret docker-registry image-pull-secret -n gpdb --docker-server=tanzu-greenplum.packages.broadcom.com --docker-username=$GPDB_USER --docker-password=$GPDB_PASSWORD
```

5. Helm Deploy (use the values.yaml in this repo)
```shell
helm install gp-operator oci://tanzu-greenplum.packages.broadcom.com/gp-operator-chart/gp-operator --version 1.0.0 -n gpdb -f values.yaml
```

### Deploy GPDB Cluster

### Deploy GPCC
---

## Cleanup
1. Stop Colima (pauses Colima and the K8s cluster)
```shell
colima stop
```
2. Delete Colima (deletes the Colima deployment and K8s cluster)
```shell
colima delete
```