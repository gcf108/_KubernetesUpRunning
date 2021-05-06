# ConfigMaps -----------------------------------------------------------------------------

# Creating ConfigMaps -------------------------------

# 11-1:  a file on disk (called my-config.txt) that we want to make available to the Pod in question

# create a ConfigMap with that file; also add a couple of simple key/value pairs here
kubectl create configmap my-config \
--from-file=my-config.txt \
--from-literal=extra-param=extra-value \
--from-literal=another-param=another-value

# The equivalent YAML for the ConfigMap object we just created is
kubectl get configmaps my-config -o yaml

# Using a ConfigMap ---------------------------

# 11-2: create a manifest for kuard that pulls all of these together

# Run this Pod and let’s port-forward to examine how the app sees the world
kubectl apply -f kuard-config.yaml

kubectl port-forward kuard-config 8080

# Secrets --------------------------------------------------------------------------------

# Creating Secrets ------------------------------

# The TLS key and certificate for the kuard application can be downloaded by
curl -O https://storage.googleapis.com/kuar-demo/kuard.crt

curl -O https://storage.googleapis.com/kuar-demo/kuard.key

# Create a secret named kuard-tls using the create secret command
kubectl create secret generic kuard-tls \
--from-file=kuard.crt \
--from-file=kuard.key

# Run the following command to get details
kubectl describe secrets kuard-tls

# Consuming Secrets -------------------------------

# Secrets volumes ----------

# 11-3: demonstrates how to declare a secrets volume, which exposes the kuard-tls secret to the kuard container under /tls

# Create the kuard-tls pod using kubectl and observe the log output from the running pod
kubectl apply -f kuard-secret.yaml

# Connect to the pod by running
kubectl port-forward kuard-tls 8443:8443

# Private Docker Registries ------------------------

# to create this special kind of secret
kubectl create secret docker-registry my-image-pull-secret \
--docker-username=<username> \
--docker-password=<password> \
--docker-email=<email-address>

# 11-4: Enable access to the private repository by referencing the image pull secret in the pod manifest file

# Managing ConfigMaps and Secrets ---------------------------------------------------------------

# Listing ----------------------------------

# list all secrets in the current namespace
kubectl get secrets

# list all of the ConfigMaps in a namespace
kubectl get configmaps

# get more details on a single object
kubectl describe configmap my-config

# see the raw data (including values in secrets!)
kubectl get configmap my-config -o yaml

kubectl get secret kuardtls -o yaml

# Creating -----------------------------------

# The easiest way to create a secret or a ConfigMap
kubectl create secret generic

kubectl create configmap

# These can be combined in a single command
:"
--from-file=<filename>
# Load from the file with the secret data key the same as the filename

--from-file=<key>=<filename>
# Load from the file with the secret data key explicitly specified

--from-file=<directory>
# Load all the files in the specified directory where the filename is an acceptable key name

--from-literal=<key>=<value>
# Use the specified key/value pair directly
"

# Updating ---------------------------------------------

# Update from file ----------------

# If you have a manifest for your ConfigMap or secret, you can just edit it directly and push a new version
kubectl replace -f <filename>

# if you previously created the resource withkubectl apply
kubectl apply -f <filename>

# Recreate and update ---------------

# If you store the inputs into your ConfigMaps or secrets as separate files on disk
kubectl create secret generic kuard-tls \
--from-file=kuard.crt --from-file=kuard.key \
--dry-run -o yaml | kubectl replace -f -

# Edit current version ------------

# to use kubectl edit to bring up a version of the ConfigMap in your editor so you can tweak it
kubectl edit configmap my-config
