IMAGE = wrnu/hello
VERSION ?= latest
DOCKER_REGISTRY ?= docker.io

.PHONY: all build test test_k8 tag push service release deploy

all: release deploy

default: build

build:
	docker build -t $(IMAGE):$(VERSION) --rm .

test:
	IMAGE=$(IMAGE) VERSION=$(VERSION) DOCKER_REGISTRY=$(DOCKER_REGISTRY) ./test/local

test_k8:
	env IMAGE=$(IMAGE) VERSION=$(VERSION) DOCKER_REGISTRY=$(DOCKER_REGISTRY) ./test/k8

tag:
	docker tag $(IMAGE):$(VERSION) $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION)

push:
	docker push $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION)

service:
	kubectl expose deployment hello --type="LoadBalancer"

release: build tag push 

deploy:
	env IMAGE=$(IMAGE) VERSION=$(VERSION) DOCKER_REGISTRY=$(DOCKER_REGISTRY) ./deploy/k8_deploy
