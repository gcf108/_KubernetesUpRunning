# Namespaces -----------------------------------------------------------------------------------------

# references objects in the mystuff namespace
kubectl --namespace=mystuff

# Contexts -------------------------------------------------------------------------------------------

# create a context with a different default namespace for your kubectl commands
kubectl config set-context my-context --namespace=mystuff

# To use this newly created context
kubectl config use-context my-context

# Viewing Kubernetes API Objects -------------------------------------------------------------------------

# get a listing of all resources in the current namespace
kubectl get <resource-name>

# get a specific resource
kubectl get <resource-name> <object-name>

# this command will extract and print the IP address of the pod
kubectl get pods my-pod -o jsonpath --template={.status.podIP}

# If you are interested in more detailed information about a particular object
kubectl describe <resource-name> <obj-name>

# Creating, Updating, and Destroying Kubernetes Objects ---------------------------------------------------------

# use kubectl to create this object in Kubernetes
kubectl apply -f obj.yaml

# use the apply command again to update the object
kubectl apply -f obj.yaml

# making interactive edits
kubectl edit <resource-name> <obj-name>

# to delete an object
kubectl delete -f obj.yaml

# delete an object using the resource type and name
kubectl delete <resource-name> <obj-name>

# Labeling and Annotating Objects --------------------------------------------------------------------------------

# to add the color=red label to a pod named bar
kubectl label pods bar color=red

# to remove a label
kubectl label pods bar -color

# Debugging Commands -------------------------------------------------------------------------------------------

# to see the logs for a running container
kubectl logs <pod-name>

# use the exec command to execute a command in a running container
kubectl exec -it <pod-name> -- bash

# copy files to and from a container
kubectl cp <pod-name>:/path/to/remote/file /path/to/local/file

# built-in help
kubectl help

kubectl help command-name
