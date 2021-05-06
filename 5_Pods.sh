# The Pod Manifest -------------------------------------------------------------------------------------

# Creating a Pod ----------------------------------------

# The simplest way to create a Pod is via the imperative kubectl run command
kubectl run kuard --image=gcr.io/kuar-demo/kuard-amd64:1

# see the status of this Pod
kubectl get pods

#  delete this Pod
kubectl delete deployments/kuard

# Creating a Pod Manifest ------------------------------------

# deployed kuard using the following Docker command
# A similar result can be achieved by instead writing 5-1-kuard-pod.yaml
docker run -d --name kuard --publish 8080:8080 gcr.io/kuar-demo/kuard-amd64:1

# Running Pods -------------------------------------------------------------------------------------------

# Use the kubectl apply command to launch a single instance of kuard
kubectl apply -f kuard-pod.yaml

# Listing Pods -----------------------

# Using the kubectl command-line tool, we can list all Pods running in the cluster.
kubectl get pods

# Pod Details ---------------------------

# To find out more information about a Pod
kubectl describe pods kuard

# Deleting a Pod ----------------------------

# delete it either by name
kubectl delete pods/kuard

# or using the same file that you used to create it
kubectl delete -f kuard-pod.yaml

# Accessing Your Pod ---------------------------------------------------------------------------------------------

# Using Port Forwarding ------------------------------

# oftentimes you simply want to access a specific Pod, even if it’s not serving traffic on the internet
kubectl port-forward kuard 8080:8080

# Getting More Info with Logs ------------------------

# downloads the current logs from the running instance
kubectl logs kuard

# Running Commands in Your Container with exec -------------------------

# to truly determine what’s going on you need to execute commands in the context of the container
kubectl exec kuard date

# get an interactive session by adding the -it flags
kubectl exec -it kuard ash

# Copying Files to and from Containers -----------------------------

# copy that file to your local machine
kubectl cp <pod-name>:/captures/capture3.txt ./capture3.txt

# copy files from your local machine into a container
kubectl cp $HOME/config.txt <pod-name>:/config.txt

# Health Checks ------------------------------------------------------------------------------------------------

# Liveness Probe -----------------------------------------

# 5-2: add a liveness probe to our kuard container, which runs an HTTP request against the /healthy path on our container

# Resource Management ------------------------------------------------------------------------------------------

# Resource Requests: Minimum Required Resources ----------------------

# 5-3: to request that the kuard container lands on a machine with half a CPU free and gets 128 MB of memory

# Capping Resource Usage with Limits ----------------

# 5-4: add a limit of 1.0 CPU and 256 MB of memory

# Persisting Data with Volumes ---------------------------------------------------------------------------------

# Using Volumes with Pods -----------------

# 5-5: defines a single new volume named kuard-data, which the kuard container mounts to the /data path

# Putting It All Together ----------------------------------------------------------------------------------

# 5-6: a combination of persistent volumes, readiness and liveness probes, and resource restrictions
