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

Keep this IP address in mind. We will need it later to access the apps running inside the cluster.

### Install the Spring Boot Apps

Now lets install the Spring Boot apps. Execute:

	kubectl apply -f spring-boot-apps.k8s.yml
	
### Install the Logging Stack

For logging we are gonna use ElasticSearch, fluentd and Kibana. We start by installing ElasticSearch. Execute:	

	kubectl apply -f elasticsearch.k8s.yml

To verify that ElasticSearch is running, forward the Port 9200 as follows:

	kubectl port-forward es-cluster-0 9200:9200 --namespace=k8s-logging
	
Then open <http://localhost:9200/_cluster/state?pretty> in your browser and you should see a response like:

	{
	  "name" : "es-cluster-0",
	  "cluster_name" : "k8s-logs",
	  "cluster_uuid" : "vDWoaedFQL2Xr3PEJjugHA",
	  "version" : {
	    "number" : "7.2.0",
	    "build_flavor" : "default",
	    "build_type" : "docker",
	    "build_hash" : "508c38a",
	    "build_date" : "2019-06-20T15:54:18.811730Z",
	    "build_snapshot" : false,
	    "lucene_version" : "8.0.0",
	    "minimum_wire_compatibility_version" : "6.8.0",
	    "minimum_index_compatibility_version" : "6.0.0-beta1"
	  },
	  "tagline" : "You Know, for Search"
	}
	
Now lets install fluentd. Execute:	

	kubectl apply -f fluentd.k8s.yml
	
To complete the logging stack install Kibana:

	kubectl apply -f kibana.k8s.yml

	