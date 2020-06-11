# Deploy

## Author

``` bash
ENV=dev
helm template -f uat.yaml -f author.yaml -f values.yaml . | kubectl apply -n p-0136-005 -f -
```

## Publish

``` bash
helm template -f uat.yaml -f publish.yaml -f values.yaml . | kubectl apply -n p-0136-005 -f -
```
