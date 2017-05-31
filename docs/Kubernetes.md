# Kubernetes

“Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.”

## Architecture

![kubernetes](https://en.wikipedia.org/wiki/File:Kubernetes.png "Kubernetes Architecture")
[Wikipedia](https://en.wikipedia.org/wiki/Kubernetes#Architecture)

## Local Install (Minikube)

“Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a VM on your laptop for users looking to try out Kubernetes or develop with it day-to-day.”

Requirements:
* Kubectl
* Hypervisor (Virtualbox, KVM, Hyper-V, VMware Fusion, xhyve)

https://github.com/kubernetes/minikube

## Concepts

### Pod

"A pod is a collection of containers sharing a network and mount namespace and is the basic unit of deployment in Kubernetes. All containers in a pod are scheduled on the same node."

[Example](http://kubernetesbyexample.com/pods/)

### Deployment

"A deployment is a supervisor for pods and replica sets, giving you fine-grained control over how and when a new pod version is rolled out as well as rolled back to a previous state."

[Example](http://kubernetesbyexample.com/deployments/)

#### Hello Deployment

Example of a deployment using our hello app.

```
$ kubectl create -f deploy/hello-deployment.yml
deployment "hello" created

$ kubectl get deployment
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello     2         2         2            0           6m

$ kubectl get pods
NAME                     READY     STATUS    RESTARTS   AGE
hello-4183362841-jgzg7   1/1       Running   0          6m
hello-4183362841-sp17d   1/1       Running   0          6m
```

### Service

"A service is an abstraction for pods, providing a stable, virtual IP (VIP) address. While pods may come and go, services allow clients to reliably connect to the containers running in the pods, using the VIP."

When using a cloud provider such as GKE, ECS, OpenStack, etc. A service would more commonly be a cloud native load balancer that distributes load to the deployment (pods).

[Example](http://kubernetesbyexample.com/services/)

#### Hello Service

Example of a service using our hello app.

```
$ kubectl expose deployment hello --type=LoadBalancer
service "hello" exposed

$ kubectl get service hello
NAME      CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
hello     10.0.0.47    <pending>     80:30878/TCP   6m

$ minikube service hello --url
http://192.168.99.100:30878
```
With minikube the EXTERNAL-IP will remain in the <pending> state. In a full cloud environment this would return the public IP of the load balancer.

Our hello app is now accessible via the EXTERNAL-IP or the url depending on your setup.

### Volume

"A Kubernetes volume is essentially a directory accessible to all containers running in a pod. In contrast to the container-local filesystem, the data in volumes is preserved across container restarts."

[Example](http://kubernetesbyexample.com/volumes/)

### Namespace

"Namespaces provide for a scope of Kubernetes objects. You can think of it as a workspace you’re sharing with other users. Many objects such as pods and services are namespaced, while some (like nodes) are not. As a developer you’d usually simply use an assigned namespace, however admins may wish to manage them, for example to set up access control or resource quotas."

[Example](http://kubernetesbyexample.com/ns/)

## Hello Kubernetes

https://github.com/wrnu/hello

Putting all of these docker and kubernetes concepts together let's build a hello app docker image and use it to deploy the hello app to our local kubernetes cluster.

### Build Docker Image & Push to Registry

[src/hello.go](https://github.com/wrnu/hello/blob/dev/src/hello.go)

```
$ docker build -t hello .
Sending build context to Docker daemon 209.4 kB
Step 1/5 : FROM golang:alpine
 ---> 56145cfd09fc
Step 2/5 : WORKDIR /app
 ---> 835a7d875e9c
Removing intermediate container 076564ba734d
Step 3/5 : COPY ./src/hello.go /app/hello.go
 ---> 4484b8fad1cb
Removing intermediate container d82db6296784
Step 4/5 : RUN go build -o hello
 ---> Running in ccacd635e390
 ---> 109e8c0cbb47
Removing intermediate container ccacd635e390
Step 5/5 : ENTRYPOINT /app/hello
 ---> Running in 3a0c6eabc34f
 ---> 91b6a1b6fb8a
Removing intermediate container 3a0c6eabc34f
Successfully built 91b6a1b6fb8a

$ docker tag hello wrnu/hello

$ docker push wrnu/hello
The push refers to a repository [docker.io/wrnu/hello]
960965c4541a: Layer already exists
204b5af761e4: Layer already exists
2997e88ddd81: Layer already exists
5206280c793f: Layer already exists
6fe86736e22d: Layer already exists
06ab4e31e630: Layer already exists
68082b2eba83: Layer already exists
ba5126b459c9: Layer already exists
e154057080f4: Layer already exists
1.0: digest: sha256:12f32737a261eaa74bbcc772ddeb2a7485823716aafe82a2e7ec25b2751a3fd7 size: 2196
```
### Deploy To Kubernetes

[deploy/hello-deployment.yml](https://github.com/wrnu/hello/blob/dev/deploy/hello-deployment.yml)

```
$ kubectl create -f deploy/hello-deployment.yml
deployment "hello" created

$ kubectl get deployment
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello     2         2         2            0           6m

$ kubectl get pods
NAME                     READY     STATUS    RESTARTS   AGE
hello-4183362841-jgzg7   1/1       Running   0          6m
hello-4183362841-sp17d   1/1       Running   0          6m

$ kubectl exec -it hello-4183362841-jgzg7 ps
PID   USER     TIME   COMMAND
    1 root       0:00 /app/hello
   20 root       0:00 ps
```

### Create Service

Create a service to expose app to external network

```
$ kubectl expose deployment hello --type=LoadBalancer
service "hello" exposed

$ kubectl get service hello
NAME      CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
hello     10.0.0.47    <pending>     80:30878/TCP   6m

$ minikube service hello --url
http://192.168.99.100:30878
```

### Update App & deploy

To update our app after a code change and re-deploy we follow the same steps above to build and push the docker image. Once we have our new image pushed to the registry we can deploy the change to the kubernetes cluster.

```
$ kubectl replace -f deploy/hello-deployment.yml
deployment "hello" replaced
```
