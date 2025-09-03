# gpdb-k8s
Instructions to run Greenplum Database (GPDB) in Kubernetes (K8s)

## ARM-based Mac/OSX Setup
### Prerequisits
1. Docker (client) Installed (e.g., Homebrew) (podman ‘should’ also work)
```shell
brew install Docker
```
1. Fully shutdown docker/podman; it will conflict if running but the client libraries must still be installed in the above step (e.g., ‘Quit Docker Desktop’ from the menu bar).
1. kubectl installed (e.g., Homebrew)
```shell
brew install kubectl
```
1. Install Colima & QEMU: (e.g., Homebrew)
```shell
brew install qemu colima lima-additional-guestagents
```
1. Install Helm (e.g., Homebrew)
```shell
brew install helm
```
