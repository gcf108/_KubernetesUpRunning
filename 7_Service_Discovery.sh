# The Service Object ----------------------------------------------------------------------------------

# Let’s create some deployments and services so we can see how they work
kubectl run alpaca-prod \
--image=gcr.io/kuar-demo/kuard-amd64:1 \
--replicas=3 \
--port=8080 \
--labels="ver=1,app=alpaca,env=prod"

kubectl expose deployment alpaca-prod

kubectl run bandicoot-prod \
--image=gcr.io/kuar-demo/kuard-amd64:2 \
--replicas=2 \
--port=8080 \
--labels="ver=2,app=bandicoot,env=prod"

kubectl expose deployment bandicoot-prod

kubectl get services -o wide

# To interact with services, we are going to port-forward to one of the alpaca pods
ALPACA_POD=$(kubectl get pods -l app=alpaca -o jsonpath='{.items[0].metadata.name}')

kubectl port-forward $ALPACA_POD 48858:8080

# Readiness Checks ----------------------------

# to add a readiness check
kubectl edit deployment/alpaca-prod

:"
spec:
  ...
  template:
    ...
    spec:
      containers:
      ...
      name: alpaca-prod
      readinessProbe:
        httpGet:
          path: /ready
          port: 8080
        periodSeconds: 2
        initialDelaySeconds: 0
        failureThreshold: 3
        successThreshold: 1
"

# need to restart our port-forward command
ALPACA_POD=$(kubectl get pods -l app=alpaca -o jsonpath='{.items[0].metadata.name}')

kubectl port-forward $ALPACA_POD 48858:8080

# to see how a Kubernetes object changes over time
kubectl get endpoints alpaca-prod --watch

# Press Control-C to exit out of both the port-forward and watch commands in your terminals

# Looking Beyond the Cluster ----------------------------------------------------------------------------

# Try this out by modifying the alpaca-prod service
kubectl edit service alpaca-prod
# Change the spec.type field to NodePort

kubectl describe service alpaca-prod

# If your cluster is in the cloud someplace, you can use SSH tunneling
ssh <node> -L 8080:localhost:32711

# Cloud Integration --------------------------------------------------------------------------------------

kubectl edit service alpaca-prod
# change spec.type to LoadBalancer

kubectl describe service alpaca-prod

# Advanced Details ---------------------------------------------------------------------------------------

# Endpoints ------------------------

# For every Service object, Kubernetes creates a buddy Endpoints object that contains the IP addresses for that service
kubectl describe endpoints alpaca-prod

# In a terminal window, start the following command and leave it running
kubectl get endpoints alpaca-prod --watch

# Now open up another terminal window and delete and recreate the deployment backing alpaca-prod
kubectl delete deployment alpaca-prod

kubectl run alpaca-prod \
--image=gcr.io/kuar-demo/kuard-amd64:1 \
--replicas=3 \
--port=8080 \
--labels="ver=1,app=alpaca,env=prod"

# Manual Service Discovery --------------------------

# With kubectl (and via the API) we can easily see what IPs are assigned to each pod
kubectl get pods -o wide --show-labels

# You’ll probably want to filter this based on the labels applied as part of the deployment
kubectl get pods -o wide --selector=app=alpaca,env=prod

# Cluster IP Environment Variables ----------------------------

# To see this in action, let’s look at the console for the bandicoot instance of kuard
BANDICOOT_POD=$(kubectl get pods -l app=bandicoot \
-o jsonpath='{.items[0].metadata.name}')

kubectl port-forward $BANDICOOT_POD 48858:8080

# Cleanup ----------------------------------------------------------------------------------------

kubectl delete services,deployments -l app
