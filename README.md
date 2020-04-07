# k8s-showcase
A Kubernetes showcase with Spring Boot, ElasticSearch, Fluentd, Kibana, Prometheus and Grafana.

## Steps to install

### Install Minikube

This guide assumes that you have VirtualBox installed on your computer or a similar virtualization software.
Install [minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/ "Minukube") on your local machine.
Create a cluster with the following parameters:

	minikube start -p k8s-showcase --memory='8192mb' --disk-size='16384mb' --vm-driver=virtualbox
 
You should see an output like this:

	* Creating virtualbox VM (CPUs=2, Memory=8192MB, Disk=16384MB) ...
	* Preparing Kubernetes v1.18.0 on Docker 19.03.8 ...
	* Enabling addons: default-storageclass, storage-provisioner
	* Done! kubectl is now configured to use "k8s-showcase"

Make sure that k8s-showcase is your current minikube profile and execute:

	minikube profile k8s-showcase
	
You should see this confirmation

	minikube profile was successfully set to k8s-showcase
	
To track and monitor what is happening in the k8s-showcase cluster, start the Kubernetes Dashbord:

	minikube dashboard
	
This will open your Browser showing the inital Dashboard screen. Now check the IP address assigned to your cluster:

	minikube ip
	
You will get a response like:

	192.168.99.104

Keep this IP address in mind or - for your own convenience - add it as host name `k8s-showcase` to `C:\Windows\System32\drivers\etc\hosts` (You need admin permission to do this). You will need it later to access the apps running inside the cluster.
 
### Deploy the full Stack

You can install everything at once. Navigate to the top level directory of the Git project and execute:

	kubectl apply -f k8s-deployment

This will apply all deployment files (*.k8s.yml) in the 'k8s-deployment' directory to your minikube cluster.

After a few minutes the cluster should have started all pods. You can now visit the installed apps by using the following links:

| URL                                  | Description                                                                                             |
|--------------------------------------|---------------------------------------------------------------------------------------------------------|
| <http://k8s-showcase:30001?name=Max> | Request to the backend (k8s-be). This will return a simmple message. It will also generate log message  |
| <http://k8s-showcase:30002?name=Max> | Request to the backend-for-frontend (k8s-bff). This will query the backend for a message and return it. |
| <http://k8s-showcase:30003>          | Opens the Spring Boot Admin UI                                                                          |
| <http://k8s-showcase:30004>          | Opens the Kibana UI                                                                                     |
| <http://k8s-showcase:30005>          | Opens the Prometheus Admin UI                                                                           |
| <http://k8s-showcase:30006>          | Opens the Grafana UI (Use admin/admin for first login)                                                  |

	