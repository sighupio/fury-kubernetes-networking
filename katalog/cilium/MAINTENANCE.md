# Cilium Package Maintenance Guide

To update the Cilium package with upstream, please follow the next steps.

## 1. Updating the values file

1.1. Download the upstream manifests

```bash
helm repo add cilium https://helm.cilium.io/
helm repo update
helm search repo cilium/cilium
helm pull cilium/cilium --version 1.17.2 --untar --untardir /tmp
```

1.2. Compare the `MAINTENANCE.values.yaml` with the one from the chart `/tmp/cilium/values.yaml` and port the changes that are needed. For example, update the image tags and check that parameters that were in use are still valid.

> 💡 **TIP**
> You can use a YAML and Kubernetes-aware tool like [Dyff](https://github.com/homeport/dyff) to compare the files. Dyff will help you to identify the differences between the manifests in a more human-readable way.
> For example:
>
> ```bash
> dyff between --ignore-whitespace-changes --ignore-order-changes /tmp/cilium/values.yaml MAINTENANCE.values.yaml
> ```

## 2. Updating the core package

2.1. Render the manifests from the upstream Chart

```bash
helm template cilium /tmp/cilium \
  --namespace kube-system \
  --values MAINTENANCE.values.yaml \
  --set hubble.enabled=false \
  --set hubble.relay.enabled=false \
  --set hubble.ui.enabled=false \
  --set hubble.metrics.enabled=null \
  --set prometheus.serviceMonitor.trustCRDsExist=true \
  > upstream-without-hubble.yaml
```

2.2. Check the differences between the manifests. Compare `core/deploy.yaml` against `upstream-without-hubble.yaml` and update `deploy.yaml` with the changes from the new version in `upstream-without-hubble.yaml` that need to be included.

## 3. Updating the hubble package

3.1. Render the manifests from the upstream Chart with Hubble enabled:

```bash
helm template cilium /tmp/cilium \
  --namespace kube-system \
  --values MAINTENANCE.values.yaml \
  --set prometheus.serviceMonitor.trustCRDsExist=true \
  > upstream-with-hubble.yaml
```

3.2. Build the kustomization project for `hubble`:

```bash
kustomize build hubble > local-with-hubble.yaml
```

3.3  Compare the output againts the file `upstream-with-hubble.yaml` to check the differences and port the changes needed to the `hubble` package modifying the `hubble/deploy.yaml` file accordingly.

### Expected differences with upstream in the Hubble package

- The monitoring resources are not included in the upstream Helm chart.
- The `self-signed-pki` resources (Issuers and CA certificates) are not included in the upstream Helm chart and have been manually added via Kustomize.
- The ServiceMonitor for the hubble metrics was fixed adding a target port on the cilium service and changing the target of the hubble ServiceMonitor.

> 💡 **TIP**
> You can comment out the monitoring resources in the `core` and `hubble`'s `kustomization.yaml` files in step 3.2 to reduce the number of differences.
> You can also comment out the self-signed-pki resource in `hubble`'s `kustomization.yaml` file to reduce the number of differences.
>
> Remember to uncomment the Kustomize project before releasing.
