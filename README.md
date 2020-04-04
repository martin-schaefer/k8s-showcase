# k8s-showcase
A Kubernetes showcase with Spring Boot, ElasticSearch, Fluentd, Kibana, Prometheus and Grafana.

## Steps to install

This guide assumes that you have VirtualBox installed on your computer or a similar virtualization software.
Install [minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/ "Minukube") on your local machine.
Create a cluster with the following parameters

	minikube start -p k8s-showcase --memory='8192mb' --disk-size='16384mb' --vm-driver=virtualbox
 
You should see an output like this

	* [k8s-showcase] minikube v1.9.0 on Microsoft Windows 10 Home 10.0.18363 Build 18363
	* Using the virtualbox driver based on user configuration
	* Creating virtualbox VM (CPUs=2, Memory=8192MB, Disk=16384MB) ...
	* Preparing Kubernetes v1.18.0 on Docker 19.03.8 ...
	* Enabling addons: default-storageclass, storage-provisioner
	* Done! kubectl is now configured to use "k8s-showcase"

To track and monitor what is happening in the k8s-showcase cluster, start the Kubernetes Dashbord:

	minikube dashboard -p k8s-showcase
	
This will open your Browser showing the inital Dashboard screen. Now check the IP address assigned to your cluster. We need this later.

	minikube ip -p k8s-showcase
	

Now lets install the Spring Boot apps. Execute:

	kubectl apply -f spring-boot-apps.k8s.yml



	