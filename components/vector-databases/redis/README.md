# Redis Deployment and Configuration

[Redis](https://redis.io/) is an open source, in-memory data store that can be used as a Vector Store for your embeddings in a Retrieval Augmented Generation scenario.

## Deplpoy using Kustomize 
```
$ oc create -f components/vector-databases/redis/base/namespace.yaml
$ oc apply -k components/vector-databases/redis/operators/overlays/default
$ oc get pods -n redis-rag -w                                                             03:47:53 PM
NAME                                        READY   STATUS    RESTARTS   AGE
rec-0                                       2/2     Running   0          2m38s
rec-1                                       2/2     Running   0          2m1s
rec-2                                       2/2     Running   0          63s
redis-enterprise-operator-9c9c4b89b-5fbrv   2/2     Running   0          2m43s
$ oc apply -k components/vector-databases/redis/instance/overlays/default
```

## Pre-requisites

- Create the project/namespace where you want to deploy your Redis cluster.
- Create the SCC needed for the Redis operator to work properly on OpenShift:

```bash
oc apply -f scc.yaml
```

- Provide the operator permissions for Redis Enterprise Operator and Cluster pods (replace `myproject` with the name of the project you created, and `rec` if you don't want to use the default name for the cluster when you will create it):

```bash
 oc adm policy add-scc-to-user redis-enterprise-scc system:serviceaccount:redis-rag:redis-enterprise-operator
 oc adm policy add-scc-to-user redis-enterprise-scc system:serviceaccount:redis-rag:rec
```

Note: repeat the previous step for every cluster you want to create or operator you want to deploy in different namespaces.

## Deployment using the Redis Enterprise Operator

- From the OperatorHub, install the Redis Enterprise Operator.

![Redis Operator](img/redis-operator.png)

- You can install the operator with the default value, in the the namespace you want to create your Redis cluster (the operator is namespace based).
- Once the operator is deployed, create a Redis cluster. You can use the following YAML definition as an example (adapt to your needs regarding size, persistency, storageClass...):

```yaml
apiVersion: app.redislabs.com/v1
kind: RedisEnterpriseCluster
metadata:
  name: rec
spec:
  serviceAccountName: rec
  redisEnterpriseNodeResources:
    limits:
      cpu: '4'
      ephemeral-storage: 10Gi
      memory: 4Gi
    requests:
      cpu: '4'
      ephemeral-storage: 1Gi
      memory: 4Gi
  bootstrapperImageSpec:
    repository: registry.connect.redhat.com/redislabs/redis-enterprise-operator
  clusterCredentialSecretName: rec
  nodes: 3
  persistentSpec:
    enabled: true
    storageClassName: gp3-csi
    volumeSize: 20Gi
  createServiceAccount: true
  username: your_admin_username
  clusterCredentialSecretRole: ''
  podStartingPolicy:
    enabled: false
    startingThresholdSeconds: 540
  redisEnterpriseServicesRiggerImageSpec:
    repository: registry.connect.redhat.com/redislabs/services-manager
  redisEnterpriseImageSpec:
    imagePullPolicy: IfNotPresent
    repository: registry.connect.redhat.com/redislabs/redis-enterprise
  uiServiceType: ClusterIP
  clusterCredentialSecretType: kubernetes
  servicesRiggerSpec:
    databaseServiceType: 'cluster_ip,headless'
    serviceNaming: bdb_name
  services:
    apiService:
      type: ClusterIP
```

- Once the Redis cluster is ready you can deploy a DataBase to host the vector store. The important parts in our scenario are to enable the **Search module**, and set **enough memory** to hold the initial index capacity. Here is an example:

```yaml
apiVersion: app.redislabs.com/v1alpha1
kind: RedisEnterpriseDatabase
metadata:
  name: my-doc
spec:
  memorySize: 4GB
  modulesList:
    - name: search
      version: 7.2.4
  persistence: snapshotEvery12Hour
  replication: true
  tlsMode: disabled
  type: redis
```

- Once the DataBase is deployed you will have:
  - A Secret named `redb-my-doc` (or the name you put in the YAML). It holds the password to the `default` user account for this database.
  - A Service named `my-doc-headless` (or the name you put in the YAML). From this Service you will get: 1. the full URL to the service from within the cluster, e.g. `my-doc-headless.my-namespace.svc.cluster.local`, 2. the port that Redis is listening to, e.g. `14155`.

- With the above information, when asked your your Redis URL in the different Notebooks or Applications on this repo, the full URI you can construct will be in the form: `redis://default:password@server:port`. With our example it would be: `redis://default:1a2b3c4d@my-doc-headless.my-namespace.svc.cluster.local:14155`.
