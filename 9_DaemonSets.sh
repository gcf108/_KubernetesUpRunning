# Creating DaemonSets -----------------------------------------------------------------

# 9-1: create a fluentd logging agent on every node in the target cluster

# create a DaemonSet to ensure the fluentd HTTP server is running on every node
kubectl apply -f fluentd.yaml

# query its current state
kubectl describe daemonset fluentd

# using the kubectl get pods command with the -o flag to print the nodes where each fluentd Pod was assigned
kubectl get pods -o wide

# Limiting DaemonSets to Specific Nodes ---------------------------------------------------

# Adding Labels to Nodes -------------------------

# adds the ssd=true label to a single node
kubectl label nodes k0-default-pool-35609c18-z7tb ssd=true

# To list only the nodes that have the ssd label set to true
kubectl get nodes --selector ssd=true

# Node Selectors -------------------------

# 9-2: The following DaemonSet configuration limits nginx to running only on nodes with the ssd=true label set

# when we submit the nginx-fast-storage DaemonSet to the Kubernetes API
kubectl apply -f nginx-fast-storage.yaml

# the nginx-fast-storage Pod will only run on that node
kubectl get pods -o wide

# Updating a DaemonSet ----------------------------------------------------------------

# Rolling Update of a DaemonSet ------------------------

# use the kubectl rollout commands to see the current status of a DaemonSet rollout
kubectl rollout status daemonSets my-daemon-set

# Deleting a DaemonSet --------------------------------------------------------------------

# Just be sure to supply the correct name of the DaemonSet you would like to delete
kubectl delete -f fluentd.yaml
