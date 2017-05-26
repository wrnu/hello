NAME = hello
VERSION ?= latest
DOCKER_REGISTRY ?= docker.io
NS ?= wrnu

.PHONY: all build test test_k8 tag push service release deploy

all: release deploy

default: build

build:
	docker build -t $(NAME):$(VERSION) --rm .

test:
	NAME=$(NAME) VERSION=$(VERSION) DOCKER_REGISTRY=$(DOCKER_REGISTRY) NS=$(NS) ./test/local

test_k8:
	env NAME=$(NAME) VERSION=$(VERSION) DOCKER_REGISTRY=$(DOCKER_REGISTRY) NS=$(NS) ./test/k8

tag:
	docker tag $(NAME):$(VERSION) $(DOCKER_REGISTRY)/$(NS)/$(NAME):$(VERSION)

push:
	docker push $(DOCKER_REGISTRY)/$(NS)/$(NAME):$(VERSION)

service:
	kubectl expose deployment $(NAME) --type="LoadBalancer"

release: build tag push 

deploy:
	env NAME=$(NAME) VERSION=$(VERSION) DOCKER_REGISTRY=$(DOCKER_REGISTRY) NS=$(NS) ./deploy/k8_deploy
