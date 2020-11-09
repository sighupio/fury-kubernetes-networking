# Configure IP Masq

If you need to specify a different masquerade configuration, take a look at this example.
In this example, both change the container argument and the configuration file.

The new argument configuration adds a new flag:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ip-masq-agent
spec:
  template:
    spec:
      containers:
      - name: ip-masq-agent
        args:
            - --masq-chain=IP-MASQ
            - --nomasq-all-reserved-ranges # This one is not shipped by default
```

Adding the following section to your `kustomization.yaml` file:

```yaml
patchesStrategicMerge:
  - daemonset-args.yml
```

Then the configuration in this example looks like:

```yaml
nonMasqueradeCIDRs:
  - 10.0.0.0/8
  - 192.168.1.0/24
resyncInterval: 60s
masqLinkLocal: true
masqLinkLocalIPv6: false
```

Adding the following section to your `kustomization.yaml` file:

```yaml
configMapGenerator:
  - name: ip-masq-agent
    behavior: merge
    files:
      - config=config.yml
```


final `kustomization.yaml` file should looks like:

```yaml
bases:
  - vendor/katalog/networking/ip-masq

patchesStrategicMerge:
  - daemonset-args.yml

configMapGenerator:
  - name: ip-masq-agent
    behavior: merge
    files:
      - config=config.yml
```

The rendered manifests contain the new configuration values.
