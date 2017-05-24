NAME = hello
VERSION ?= latest
DOCKER_REGISTRY = hellotest.azurecr.io

.PHONY: all build test test_k8 tag push release deploy

all: build

default: build

build:
	docker build -t $(NAME):$(VERSION) --rm .

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./test/test_local

test_k8:
	env NAME=$(NAME) VERSION=$(VERSION) ./test/test_azure

tag:
	docker tag $(NAME):$(VERSION) $(DOCKER_REGISTRY)/$(NAME):$(VERSION)

push:
	docker push $(DOCKER_REGISTRY)/$(NAME):$(VERSION)

release: build tag push 

deploy:
	env NAME=$(NAME) VERSION=$(VERSION) ./deploy/az_k8_deploy
