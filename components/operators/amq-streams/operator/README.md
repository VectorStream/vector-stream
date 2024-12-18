# AMQ Streams Operator

Installs the AMQ Streams operator into all namespaces.

Current channel overlays include:
* [amq-streams-2.1.x](overlays/2.x)
* [stable](overlays/stable)

## Usage

If you have cloned the `gitops-catalog` repository, you can install the AMQ Streams operator based on the overlay of your choice by running from the root `gitops-catalog` directory

```
oc apply -k components/operators/amq-streams/operator/overlays/stable
```

Or, without cloning:

```
oc apply -k https://github.com/redhat-cop/gitops-catalog/amq-streams-operator/operator/overlays/<channel>
```

As part of a different overlay in your own GitOps repo:

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - github.com/redhat-cop/gitops-catalog/amq-streams-operator/operator/overlays/<channel>?ref=main
```