Here's a README file incorporating the information from both provided links:

---

# Milvus Deployment on OpenShift and Kubernetes

This README provides guidance on deploying a Milvus cluster on OpenShift and Kubernetes using Milvus Operator.

## Table of Contents
- [Milvus Deployment on OpenShift and Kubernetes](#milvus-deployment-on-openshift-and-kubernetes)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Prerequisites](#prerequisites)
  - [Deploying Milvus on OpenShift](#deploying-milvus-on-openshift)
  - [Deploying Milvus on Kubernetes](#deploying-milvus-on-kubernetes)
  - [Resources](#resources)

## Introduction

Milvus is a highly scalable vector database optimized for similarity search workloads. Deploying Milvus on OpenShift and Kubernetes ensures efficient management and scalability of your data infrastructure.

## Prerequisites

- Access to a running OpenShift or Kubernetes cluster with necessary privileges.
- Installed OpenShift Container Platform (for OpenShift deployments).
- Installed Cert Manager for managing TLS certificates.
- Helm installed (version 3.x is recommended).
- Familiarity with Kubernetes Custom Resources.

## Deploying Milvus on OpenShift

Follow the detailed guide to deploy Milvus on OpenShift:

1. **Cert Manager Installation**: Install Cert Manager to manage certificates for Milvus Operator. Follow the [Cert Manager Installation Guide](https://cert-manager.io/docs/installation/).

2. **Milvus Operator Manual Installation**:
   - Add the Milvus Operator Helm repository:
     ```bash
     helm repo add milvus-operator https://zilliztech.github.io/milvus-operator/
     helm repo update
     ```
   - Install the Milvus Operator:
     ```bash
     helm -n milvus-operator upgrade --install --create-namespace milvus-operator milvus-operator/milvus-operator
     ```
3. **Deploy Milvus**: Once the operator is installed, deploy the Milvus cluster using the appropriate YAML configuration file.

For full instructions, visit the [Deploy Milvus Cluster on OpenShift](https://milvus.io/docs/openshift.md) documentation.

## Deploying Milvus on Kubernetes

To deploy Milvus with the Milvus Operator on Kubernetes, follow these steps:

1. **Milvus Operator Manual Installation**:
   - With Helm:
     ```bash
     helm install milvus-operator -n milvus-operator --create-namespace https://github.com/zilliztech/milvus-operator/releases/download/v1.0.1/milvus-operator-1.0.1.tgz
     ```
   - With kubectl:
     ```bash
     kubectl apply -f https://raw.githubusercontent.com/zilliztech/milvus-operator/main/deploy/manifests/deployment.yaml
     ```

2. **Deploy Milvus Cluster**:
   - Deploy using a default configuration:
     ```bash
     kubectl apply -f https://raw.githubusercontent.com/zilliztech/milvus-operator/main/config/samples/milvus_cluster_default.yaml
     ```

3. **Deploy Cluster using kustomize**:
   - Clone the Milvus Operator repository:
     ```bash
     kustomize build components/vector-databases/milvus/overlays/cluster | oc create -f - 
     ```

For complete instructions, refer to the [Install Milvus Cluster with Milvus Operator](https://milvus.io/docs/install_cluster-milvusoperator.md#Deploy-Milvus) guide.

## Resources

- [Milvus Documentation](https://milvus.io/docs/)
- [Milvus GitHub Repository](https://github.com/milvus-io/milvus)
- [Milvus Operator GitHub Repository](https://github.com/zilliztech/milvus-operator)

--- 

This README provides a consolidated overview of deploying Milvus on OpenShift and Kubernetes environments. For detailed steps and troubleshooting, please visit the linked documentation pages.