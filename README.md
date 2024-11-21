# vector-stream

## Workload Deployment Instructions for OpenShift 4.16
[Deployment Workload Instuctions for OpenShift 4.16 ](deployment_workload.md)

## Developing on OpenShift version
* 4.16.16

```sh
kustomize build clusters/overlays/rhoai-vector-stream-development | oc create -f -
```

Links: 
* https://opea-project.github.io/latest/index.html
