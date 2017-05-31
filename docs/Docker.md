# Docker
“Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications, whether on laptops, data center VMs, or the cloud.”

## Install
https://www.docker.com/community-edition#/download

## Concepts

### Image
- [Glossary](https://docs.docker.com/glossary/?term=image)
- [Docs](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/#images-and-layers)

**tl;dr**

A docker image built is from a Dockerfile, each layer corresponds to an instruction in the Dockerfile. Images are used by the docker engine (as a template) to create containers.

### Container
- [Glossary](https://docs.docker.com/glossary/?term=container)
- [Docs](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/#container-and-layers)

**tl;dr**

A container is an instance of a docker image. Containers are crated by the docker engine (runtime / daemon) by adding a writeable layer on top of the image.

### Docker Client
Docker client is the `docker` binary, it talks to the docker daemon. The docker daemon can be local or remote.

e.g. docker ps

### Docker Daemon
Docker daemon does the heavy lifting of building, running, and distributing your Docker containers.

e.g. systemctl start docker

### Dockerfile
- [Glossary](https://docs.docker.com/glossary/?term=dockerfile)
- [Docs](https://docs.docker.com/engine/reference/builder/)

```
"A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image."
```

```
FROM golang:alpine

WORKDIR /app

COPY ./src/hello.go /app/hello.go

RUN go build -o hello

ENTRYPOINT ["/app/hello"]
```

`docker build` is used to create an image from a `Dockerfile`.

e.g. `docker build -t wrnu/hello .`

### Repository
- [Glossary](https://docs.docker.com/glossary/?term=repository)
- [Docs](https://docs.docker.com/registry/)

**tl;dr**

A docker repository is like a git repository for docker images.

### Registry
- [Glossary](https://docs.docker.com/glossary/?term=registry)
- [Docs](https://docs.docker.com/registry/)

**tl;dr**

A docker registry is like a GitHub for docker images. A service that hosts image repositories.

### Volume
- [Glossary](https://docs.docker.com/glossary/?term=volume)
- [Docs](https://docs.docker.com/engine/tutorials/dockervolumes/)

**tl;dr**

Volumes are used to persist data.

## Hello World

A simple go web application that has two features:

- GET on /
  - “Hello world!”
- POST "POST_DATA" on /
  - “Hello POST_DATA world!”

https://github.com/wrnu/hello

```
$ docker run --name hello -p 80:80 -d wrnu/hello
$ curl http://localhost
Hello world!

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                NAMES
87407f7dbf47        wrnu/hello          "/app/hello"        3 seconds ago       Up 1 second         0.0.0.0:80->80/tcp   hello

$ docker run --name hello -p 80:80 -d wrnu/hello
$ curl -X POST --data "Docker" http://localhost
Hello Docker world!
```
