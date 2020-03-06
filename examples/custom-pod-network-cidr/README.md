# Custom pod network cidr

If the cluster has another pod network cidr different than `172.16.0.0/16` you can create a `patch.yaml` file:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: calico-node
spec:
  template:
    spec:
      containers:
        - name: calico-node
          env:
          - name: CALICO_IPV4POOL_CIDR
            value: "192.168.0.0/16" # PUT YOUR NETWORK CIDR HERE
```

Adding the following section to your `kustomization.yaml` file:

```yaml
patchesStrategicMerge:
  - patch.yaml
```

final `kustomization.yaml` file should looks like:

```yaml
bases:
  - ./vendor/katalog/networking/calico

patchesStrategicMerge:
  - patch.yaml
```

The rendered manifests contains the new `CALICO_IPV4POOL_CIDR` value.
