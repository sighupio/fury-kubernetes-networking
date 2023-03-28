# Cilium Package Maintenance Guide

To update the Calico package with upstream, please follow the next steps.

Download the upstream manifests:

```bash
helm pull cilium/cilium --version 1.13.1 --untar --untardir /tmp
```

Change the tag for the images on the file `MAINTENANCE.values.yaml`, check the new one on `/tmp/cilium/values.yaml

Render the manifests:

```bash
# before running helm template, remove from the /tmp/cilium/templates/validation.yaml the ServiceMonitor capability check, otherwise it will not work
helm template cilium /tmp/cilium --namespace kube-system --values MAINTENANCE.values.yaml > built-with-hubble.yaml
helm template cilium /tmp/cilium --namespace kube-system --values MAINTENANCE.values.yaml \
  --set hubble.enabled=false \
  --set hubble.relay.enabled=false \
  --set hubble.ui.enabled=false \
  --set hubble.metrics.enabled=false > built-without-hubble.yaml
```

You need the version with hubble enabled and one version with hubble disabled, to check differences between the two
deployments and assure that the folder `hubble` contains the correct patches to cilium without hubble, `core` folder.

Check differences between `core/deploy.yaml` and `built-without-hubble.yaml` and update accordingly.

Then, create a dummy kustomization project with the file `built-with-hubble.yaml` as resource, and build it:

```bash
kustomize build dummy-project > built-from-helm.yaml
```

Now build the current project:

```bash
kustomize build . > built.yaml
```

And check the differences betweeen `built-from-helm.yaml` and `built.yaml`

Beware that we changed how we generate the base CA from helm to cert-manager using a self-signed CA.