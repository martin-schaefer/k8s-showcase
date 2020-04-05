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

Write this IP address down, we will need it later to access the apps running inside the cluster

### Install the Spring Boot Apps

Now lets install the Spring Boot apps. Execute:

	kubectl apply -f spring-boot-apps.k8s.yml
	
### Install the Logging Stack

For logging we are gonna use ElasticSearch, fluentd and Kibana. We start by installing ElasticSearch. Execute:	

	kubectl apply -f elasticsearch.k8s.yml

	