# Your First Deployment ----------------------------------------------------------------------------------

#  created a Pod by running kubectl run
kubectl run nginx --image=nginx:1.7.12

# view this Deployment object by running
kubectl get deployments nginx

# Deployment Internals ------------------------------------------

# see the label selector by looking at the Deployment object
kubectl get deployments nginx \
-o jsonpath --template {.spec.selector.matchLabels}

# use this in a label selector query across ReplicaSets to find that specific ReplicaSet
kubectl get replicasets --selector=run=nginx

# resize the Deployment using the imperative scale command
kubectl scale deployments nginx --replicas=2

# if we list that ReplicaSet again
kubectl get replicasets --selector=run=nginx

# let’s try the opposite, scaling the ReplicaSet
kubectl scale replicasets nginx-1128242161 --replicas=1

# get that ReplicaSet again
kubectl get replicasets --selector=run=nginx

# Creating Deployments -----------------------------------------------------------------------------------

# download this Deployment into a YAML file
kubectl get deployments nginx --export -o yaml > nginx-deployment.yaml

kubectl replace -f nginx-deployment.yaml --save-config

# Managing Deployments -----------------------------------------------------------------------------------

# get detailed information about your Deployment
kubectl describe deployments nginx

# Updating Deployments ---------------------------------------------------------------------------------

# Scaling a Deployment--------------------------------------

# update the Deployment using the kubectl apply command
kubectl apply -f nginx-deployment.yaml

# eventually create a new Pod managed by the Deployment
kubectl get deployments nginx

# Updating a Container Image -----------------------------

# use kubectl apply to update the Deployment
kubectl apply -f nginx-deployment.yaml

# monitor via the kubectl rollout command
kubectl rollout status deployments nginx

# Both the old and new ReplicaSets are kept around in case you want to roll back
kubectl get replicasets -o wide

# If you are in the middle of a rollout and you want to temporarily pause it for some reason
kubectl rollout pause deployments nginx

# If, after investigation, you believe the rollout can safely proceed
kubectl rollout resume deployments nginx

# Rollout History ---------------------------------

# see the deployment history by running
kubectl rollout history deployment nginx

# If you are interested in more details about a particular revision
kubectl rollout history deployment nginx --revision=2

# simply undo the last rollout
kubectl rollout undo deployments nginx

# roll back to a specific revision in the history
kubectl rollout undo deployments nginx --to-revision=3

# Specifying a revision of 0 is a shorthand way of specifying the previous revision
kubectl rollout undo

kubectl rollout undo --torevision=0

# Deleting a Deployment ------------------------------------------------------------------------------

# with the imperative command
kubectl delete deployments nginx

# using the declarative YAML file
kubectl delete -f nginx-deployment.yaml
