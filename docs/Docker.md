# Docker
“Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications, whether on laptops, data center VMs, or the cloud.”

## Install
https://www.docker.com/community-edition#/download

## Concepts

### Image

### Container

### Docker Engine

### Dockerfile

### Registry

### Volume

## Hello World

A simple go web application that has two features:

* GET on /
..* “Hello world!”
* POST on /
..* “Hello POST_DATA world!”

https://github.com/wrnu/hello

```
$ docker run --name hello -p 80:80 -d wrnu/hello
$ curl http://localhost
Hello world!

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                NAMES
87407f7dbf47        wrnu/hello          "/app/hello"        3 seconds ago       Up 1 second         0.0.0.0:80->80/tcp   hello

$ docker run --name hello -p 80:80 -d wrnu/hello
$ curl -X POST --data "GE" http://localhost
Hello GE world!
```

## Dockerfile

```
FROM golang:alpine

WORKDIR /app

COPY ./src/hello.go /app/hello.go

RUN go build -o hello

ENTRYPOINT ["/app/hello"]
```

## Registry
“The Registry is a stateless, highly scalable server side application that stores and lets you distribute Docker images.”
