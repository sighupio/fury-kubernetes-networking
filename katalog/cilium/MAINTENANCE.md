# Cilium Package Maintenance Guide

To update the Cilium package with upstream, please follow the next steps.

Download the upstream manifests:

```bash
helm repo add cilium https://helm.cilium.io/
helm repo update
helm search repo cilium/cilium
helm pull cilium/cilium --version 1.16.3 --untar --untardir /tmp
```

Change the tag for the images on the file `MAINTENANCE.values.yaml`, check the
new one on `/tmp/cilium/values.yaml`

Render the manifests:

```bash
# before running helm template, remove from the /tmp/cilium/templates/validate.yaml
# the ServiceMonitor capability check, otherwise it will not work
helm template cilium /tmp/cilium --namespace kube-system --values MAINTENANCE.values.yaml > built-with-hubble.yaml
helm template cilium /tmp/cilium --namespace kube-system --values MAINTENANCE.values.yaml \
  --set hubble.enabled=false \
  --set hubble.relay.enabled=false \
  --set hubble.ui.enabled=false \
  --set hubble.metrics.enabled=null > built-without-hubble.yaml
```

You need one version with hubble enabled and one version with hubble disabled, to
check differences between the two deployments and assure that the folder `hubble`
contains the correct patches to cilium without hubble, `core` folder.

Check differences between `core/deploy.yaml` and `built-without-hubble.yaml` and
update accordingly.

Then, create a dummy kustomization project with the file `built-with-hubble.yaml`
as resource, and build it:

```bash
mkdir dummy
cp built-with-hubble.yaml dummy
echo -e "resources:\n- built-with-hubble.yaml" > dummy/kustomization.yaml
kustomize build dummy > built-from-helm.yaml
# Now build the current project:
kustomize build . > built.yaml
```

And check the differences betweeen `built-from-helm.yaml` and `built.yaml`

Beware that we changed how we generate the base CA from helm to cert-manager using
a self-signed CA, and also, we fixed the ServiceMonitor for the hubble metrics,
adding a target port on the cilium service and changing the target of the hubble
ServiceMonitor.

Once you're done aligning the manifest with upstream, replace the old one `hubble/deploy.yaml`
with the newly built `built.yaml`:

```sh
mv built.yaml hubble/deploy.yaml
```
