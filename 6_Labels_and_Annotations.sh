# Labels ----------------------------------------------------------------------------------------------

# Applying Labels --------------------------------------

# First, create the alpaca-prod deployment and set the ver, app, and env labels
kubectl run alpaca-prod \
--image=gcr.io/kuar-demo/kuard-amd64:1 \--replicas=2 \
--labels="ver=1,app=alpaca,env=prod"

# Next, create the alpaca-test deployment and set the ver, app, and env labels with the appropriate values
kubectl run alpaca-test \
--image=gcr.io/kuar-demo/kuard-amd64:2 \
--replicas=1 \
--labels="ver=2,app=alpaca,env=test"

# Finally, create two deployments for bandicoot. Here we name the environments prod and staging
kubectl run bandicoot-prod \
--image=gcr.io/kuar-demo/kuard-amd64:2 \
--replicas=2 \
--labels="ver=2,app=bandicoot,env=prod"

kubectl run bandicoot-staging \
--image=gcr.io/kuar-demo/kuard-amd64:2 \
--replicas=1 \
--labels="ver=2,app=bandicoot,env=staging"

# At this point you should have four deployments
kubectl get deployments --show-labels

# Modifying Labels ----------------------

# Labels can also be applied (or updated) on objects after they are created
kubectl label deployments alpaca-test "canary=true"

# use the -L option to kubectl get to show a label value as a column
kubectl get deployments -L canary

# remove a label by applying a dash suffix
kubectl label deployments alpaca-test "canary-"

# Label Selectors ------------------------

# Running the kubectl get pods command should return all the Pods currently running in the cluster
kubectl get pods --show-labels

# If we only wanted to list pods that had the ver label set to 2
kubectl get pods --selector="ver=2"

# specify two selectors separated by a comma. This is a logical AND operation
kubectl get pods --selector="app=bandicoot,ver=2"

# ask if a label is one of a set of values
kubectl get pods --selector="app in (alpaca,bandicoot)"

# ask if a label is set at all
kubectl get deployments --selector="canary"

# Label Selectors in API Objects ---------------------------------

# A selector of app=alpaca,ver in (1, 2) would be converted to this
: "
selector:
  matchLabels:
    app: alpaca
  matchExpressions:
  - {key: ver, operator: In, values: [1, 2]}
"

# The selector app=alpaca,ver=1 would be represented like this
:"
selector:
  app: alpaca
  ver: 1
"

# Annotations ----------------------------------------------------------------------------------------

# Defining Annotations ------------------------

# Example keys include
:"
deployment.kubernetes.io/revision

kubernetes.io/change-cause
"

# Annotations are defined in the common metadata section in every Kubernetes object
:"
...
metadata:
  annotations:
    example.com/icon-url: "https://example.com/icon.png"
...
"
# Cleanup ---------------------------------------------------------------------------------------------

# It is easy to clean up all of the deployments
kubectl delete deployments --all

# If you want to be more selective you can use the --selector flag to choose which deployments to delete
