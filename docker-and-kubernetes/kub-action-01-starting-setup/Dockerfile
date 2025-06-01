FROM node:14-alpine

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 8080

CMD [ "node", "app.js" ]


# docker build -t kub-first-app .
# docker tag kub-first-app omarsalim/kub-first-app
# docker login
# docker push omarsalim/kub-first-app

# kubectl create deployment first-app --image=omarsalim/kub-first-app

# kubectl get deployments
# kubectl get pods

# kubectl delete deployment first-app

# kubectl expose deployment first-app --type=LoadBalancer --port=8080
# --type=ClusterIP : means it will only be accessible from within the cluster
# --type=NodePort : this deployment should be exposed with help of worker-node IP-Address aka means it will be accessible from outside the cluster.
# --type=LoadBalancer : this deployment should be exposed with help of LoadBalancer and evenly distribute the traffic to all the worker nodes.
#   note for `--type=LoadBalancer`, it will only be available if you are using a cloud provider like AWS, GCP, or Azure or locally minikube.
# --port=8080 means it's exposing the app port 8080

# kubectl get services
# you can see the EXTERNAL-IP of the service that you exposed using <kubectl expose command>.


# kubectl scale deployment/first-app --replicas=3
#  --replicas=3 means we want to run 3 instances (scale-up) of the same deployment which is 3 pods in this case.
# kubectl get pods
# -- check how many pods are running, it should be 3 now.
# kubectl scale deployment/first-app --replicas=1
# --replicas=1 means we want to run 1 instance (scale-down) of the same deployment which is 1 pod in this case.
# kubectl get pods
# -- check how many pods are running, it should be 1 now.

# updating a deployment.
# kubectl get deployments
# - to check the current deployment is still running or not.
# kubectl set image deployment/first-app kub-first-app=omarsalim/kub-first-app:latest
# - to update the image of the deployment.

# CASE: if you want to update the image of the deployment with a new image that does not exist
# kubectl set image deployment/first-app kub-first-app=omarsalim/kub-first-app:3
# - FYI image: `omarsalim/kub-first-app:3` does not exist.
# kubectl rollout status deployment/first-app
# - to check the status of the deployment.
# kubectl rollout undo deployment/first-app
# - to rollback the deployment to the previous version. and rollback latest deployment to the previous version.
# kubectl rollout history deployment/first-app
# - to check the history of the deployment.
# kubectl rollout history deployment/first-app --revision=2
# - to check the history details of the deployment with revision number 2.
# kubectl rollout undo deployment/first-app --to-revision=1
# - to rollback the deployment to the previous version with revision number 1.


# minikube dashboard

# minikube service first-app
#   - special command to access the service from the browser


# Clean-up
# kubectl delete service first-app
# - first start with the service to delete the loadbalancer service.
# kubectl delete deployment first-app
# - then delete the deployment.