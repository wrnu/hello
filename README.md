# Kubernetes Hello World

## Build and Push App To Registry
```
# Builds local image
make build

# Builds and pushes as tag:latest
make release

# Builds and pushes as tag:1.0
VERSION=1.0 make release
```

## Test
```
# Test tag:latest with local docker
make test

# Test tag:1.0
VERSION=1.0 make test with local docker
```

## Deploy
```
# Deploy tag:latest to active k8 cluster
make deploy

# Deploy tag:1.0 to active k8 cluster
VERSION=1.0 make deploy
```

## Delete Deployment
```
# Deploy tag:latest to active k8 cluster
make delete

# Deploy tag:1.0 to active k8 cluster
VERSION=1.0 make delete
```
