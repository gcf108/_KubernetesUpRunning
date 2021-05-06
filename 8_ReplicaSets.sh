# ReplicaSet Spec ---------------------------------------------------------------------------------

# Pod Templates -------------------------------

# The following shows an example of a Pod template in a ReplicaSet
:"
template:
  metadata:
    labels:
      app: helloworld
      version: v1
  spec:
    containers:
      - name: helloworld
        image: kelseyhightower/helloworld:v1
        ports:
          - containerPort: 80
"

# Creating a ReplicaSet ----------------------------------------------------------------------------

# Use the kubectl apply command to submit the kuard ReplicaSet to the Kubernetes API
kubectl apply -f kuard-rs.yaml

kubectl get pods

# Inspecting a ReplicaSet ---------------------------------------------------------------------------

# using describe to obtain the details of the ReplicaSet
kubectl describe rs kuard

# Finding a ReplicaSet from a Pod --------------

# look for the kubernetes.io/created-by entry in the annotations section
kubectl get pods <pod-name> -o yaml

# Finding a Set of Pods for a ReplicaSet -----------------

# To find the Pods that match this selector, use the --selector flag or the shorthand -l
kubectl get pods -l app=kuard,version=2

# Scaling ReplicaSets --------------------------------------------------------------------------------

# Imperative Scaling with kubectl Scale -------------

# to scale up to four replicas you could run
kubectl scale kuard --replicas=4

# Declaratively Scaling with kubectl apply ----------------

# edit the kuard-rs.yaml configuration file and set the replicas count to 3
:"
...
spec:
  replicas: 3
...
"

# use the kubectl apply command to submit the updated kuard ReplicaSet to the API server
kubectl apply -f kuard-rs.yaml

# use the kubectl get pods command to list the running kuard Pods
kubectl get pods

# Autoscaling a ReplicaSet --------------------------

# validate heapster presence by listing the Pods in the kube-system namespace
kubectl get pods --namespace=kube-system

# Autoscaling based on CPU -----

# To scale a ReplicaSet, you can run a command
kubectl autoscale rs kuard --min=2 --max=5 --cpu-percent=80

# To view, modify, or delete this resource you can use the standard kubectl commands and the horizontalpodautoscalers resource
kubectl get hpa

# Deleting ReplicaSets ---------------------------------------------------------------------------

# By default, this also deletes the Pods that are managed by the ReplicaSet
kubectl delete rs kuard

kubectl get pods

# If you don’t want to delete the Pods that are being managed by the ReplicaSet
kubectl delete rs kuard --cascade=false
