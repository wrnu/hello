IMAGE = wrnu/hello
VERSION ?= latest
DOCKER_REGISTRY ?= docker.io
NAMESPACE ?= default

.PHONY: all build test tag push release deploy delete

all: release deploy

default: build

build:
	docker build -t $(IMAGE):$(VERSION) --rm .

test:
	IMAGE=$(IMAGE) VERSION=$(VERSION) DOCKER_REGISTRY=$(DOCKER_REGISTRY) ./test/local

tag:
	docker tag $(IMAGE):$(VERSION) $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION)

push:
	docker push $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION)

release: build tag push 

deploy:
	helm template -f helm/values.yaml --set imageName=$(IMAGE) --set imageTag=$(VERSION) --set environment=dev helm/ | kubectl apply -n $(NAMESPACE) -f -

delete:
	helm template -f helm/values.yaml --set imageName=$(IMAGE) --set imageTag=$(VERSION) --set environment=dev helm/ | kubectl delete -n $(NAMESPACE) -f -

