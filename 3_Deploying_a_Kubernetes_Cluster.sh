# The Kubernetes Client --------------------------------------------------------------------------------

# Checking Cluster Status ----------------------------

# check the version of the cluster that you are running
kubectl version

# to verify that your cluster is generally healthy
kubectl get componentstatuses

# Listing Kubernetes Worker Nodes ---------------------

# list out all of the nodes in our cluster
kubectl get nodes

# to get more information about a specific node such as node-1
kubectl describe nodes node-1

# Cluster Components -------------------------------------------------------------------------------------------

# Kubernetes Proxy --------------------------------------

# see the proxies by running
kubectl get daemonSets --namespace=kube-system kube-proxy

# Kubernetes DNS ---------------------------------------

# you may see one or more DNS servers running in your cluster:
kubectl get deployments --namespace=kube-system kube-dns

# a Kubernetes service that performs load-balancing for the DNS server
kubectl get services --namespace=kube-system kube-dns

# Kubernetes UI ---------------------------------------------

# You can see this UI server using
kubectl get deployments --namespace=kube-system kubernetes-dashboard

# The dashboard also has a service that performs load balancing for the dashboard
kubectl get services --namespace=kube-system kubernetes-dashboard

# We can use the kubectl proxy to access this UI
kubectl proxy
