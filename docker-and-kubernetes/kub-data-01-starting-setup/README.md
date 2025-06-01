# Steps

- make sure no deployment in your minikube

```bash
kubectl get deployments
```

- run docker build and then push your image, make sure you're logged-in:

```bash
docker login
```

```bash
docker build -t omarsalim/kub-data-demo .
```

```bash
docker push omarsalim/kub-data-demo
```

- make sure your minikube is up and running

```bash
minikube status
```

- if it's stopped restart it by:

```bash
minikube start --driver=docker
```

- then apply the following yaml files, it's recommended to start with creating a service before deployment.

```bash
kubectl apply -f=service.yml -f=deployment.yml
```

```bash
kubectl get deployments
kubectl get services
```

- to reach to that service and expose it to open world

```bash
minikube service story-service
```

visit: https://kubernetes.io/docs/concepts/storage/volumes/
to learn more about supported cloud provider volume storage.

- orders matter here

```bash
kubectl apply -f=host-pv.yml
```

```bash
kubectl apply -f=host-pvc.yml
```

```bash
kubectl apply -f=deployment.yml
```

```bash
kubectl get pv
kubectl get pvc
kubectl get deployment
```
