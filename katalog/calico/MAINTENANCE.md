# Calico Package maintenance instructions

To update the Calico package with upstream, please follow the next steps:

## Updating calico itself

1. Download upstream manifests:

```bash
export CALICO_VERSION=3.21
curl -L https://docs.projectcalico.org/archive/v${CALICO_VERSION}/manifests/calico.yaml -o calico-${CALICO_VERSION}.yaml
```

2. Diff the downloaded manifest with the module's manifests:

```bash
# Let's generate a merged YAML to compare first
# ⚠️ assuming $PWD==katalog/calico
cat config.yml crd.yml rbac.yml ds.yml deploy.yml pdb.yml > merge.yaml
```

Compare the `merge.yaml` file with the downloaded `calico-${CALICO_VERSION}` file from upstream and port the necessary changes.

> ⚠️ Remember to drop the namespace from the files, becuase it is being added by Kustomize.

1. Update the `kustomization.yaml` file with the right image versions.

```bash
export CALICO_IMAGE_TAG=v3.21.3
kustomize edit set image docker.io/calico/kube-controllers=registry.sighup.io/fury/calico/kube-controllers:${CALICO_IMAGE_TAG}
kustomize edit set image docker.io/calico/cni=registry.sighup.io/fury/calico/cni:${CALICO_IMAGE_TAG}
kustomize edit set image docker.io/calico/node=registry.sighup.io/fury/calico/node:${CALICO_IMAGE_TAG}
kustomize edit set image docker.io/calico/pod2daemon-flexvol=registry.sighup.io/fury/calico/pod2daemon-flexvol:${CALICO_IMAGE_TAG}
```

> ⚠️ Remember to check if images have been added to or dropped from upstream.

4. Update the README.md file.

## Updating monitoring components

The resources needed to provide monitoring features are not included in the default upstream manifests. There are some additional steps to perform.

See <https://projectcalico.docs.tigera.io/archive/v3.23/maintenance/monitor/monitor-component-metrics> for details. Note that we are adding an environment variable to the DaemonSet instead of modifing the `default` instance of the `felixconfigurations.crd.projectcalico.org` CRD as the docs say. Modifing the CRD is not possible using Kustomize patches.

1. Download the dashboard from upstream:

```bash
export CALICO_VERSION=3.21
# ⚠️ Assuming $PWD==katalog/calico
# We take the `felix-dashboard.json` from the downloaded yaml, we are not deploying `typha`, so we don't need its dashboard.
curl https://projectcalico.docs.tigera.io/archive/v${CALICO_VERSION}/manifests/grafana-dashboards.yaml | yq '.data["felix-dashboard.json"]' | jq > ./monitoring/dashboards/felix-dashboard.json
```
