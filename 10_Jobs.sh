# Job Patterns ------------------------------------------------------------------------------

# One Shot -------------------------------------

# There are multiple ways to create a one-shot Job in Kubernetes. The easiest is to use the kubectl
kubectl run -i oneshot \
--image=gcr.io/kuar-demo/kuard-amd64:1 \
--restart=OnFailure \
-- --keygen-enable \
   --keygen-exit-on-complete \
   --keygen-num-to-gen 10

# Delete the Job before continuing
kubectl delete jobs oneshot

# 10-1: The other option for creating a one-shot Job is using a configuration file

# Submit the job using the kubectl apply command
kubectl apply -f job-oneshot.yaml

# Then describe the oneshot job
kubectl describe jobs oneshot

# You can view the results of the Job by looking at the logs of the pod that was created
kubectl logs oneshot-4kfdt

# Pod failure ----------

# 10-2: Let’s modify the arguments to kuard in our configuration file to cause it to fail out with a nonzero exit code

kubectl apply -f jobs-oneshot-failure1.yaml

kubectl get pod -a -l job-name=oneshot

kubectl delete jobs oneshot

# Modify the config file again and change the restartPolicy from OnFailure to Never

kubectl apply -f jobs-oneshot-failure2.yaml

kubectl get pod -l job-name=oneshot -a

kubectl delete jobs oneshot

# Parallelism ------------------------------------

# 10-2: This translates to setting completions to 10 and parallelism to 5

kubectl apply -f job-parallel.yaml

# use the --watch flag to have kubectl stay around and list changes as they happen

kubectl get pods -w

kubectl delete job parallel

# Work Queues --------------------------------------

# Starting a work queue -----------

# 10-4: Create a simple ReplicaSet to manage a singleton work queue daemon

kubectl apply -f rs-queue.yaml

# use port forwarding to connect to it. Leave this command running in a terminal window
QUEUE_POD=$(kubectl get pods -l app=work-queue,component=queue \
-o jsonpath='{.items[0].metadata.name}')

kubectl port-forward $QUEUE_POD 8080:8080

# 10-5: With the work queue server in place, we should expose it using a service

kubectl apply -f service-queue.yaml

# Loading up the queue -------------

# 10-6: curl will communicate to the work queue through the kubectl port-forward we set up earlier

# Create a work queue called 'keygen'
curl -X PUT localhost:8080/memq/server/queues/keygen

# Create 100 work items and load up the queue.
for i in work-item-{0..99}; do
  curl -X POST localhost:8080/memq/server/queues/keygen/enqueue \
    -d "$i"
done

# you can ask the work queue API directly
curl 127.0.0.1:8080/memq/server/stats

# Creating the consumer job --------------

# 10-7: set it up to draw work items from the work queue, create a key, and then exit once the queue is empty

# Create the consumers Job
kubectl apply -f job-consumers.yaml

# Once the Job has been created you can view the pods backing the Job
kubectl get pods

# Cleaning up -----------

# Using labels we can clean up all of the stuff we created in this section
kubectl delete rs,svc,job -l chapter=jobs
