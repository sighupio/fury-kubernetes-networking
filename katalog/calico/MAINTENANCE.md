# Calico Package maintenance instructions

To update the Calico package with upstream, please follow the next steps:

## Updating calico itself

1. Download upstream manifests:

```bash
export CALICO_VERSION=3.27.3
curl -L https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/calico.yaml -o calico-${CALICO_VERSION}.yaml
```

2. Diff the downloaded manifest with the module's manifests:

Compare the `deploy.yaml` file with the downloaded `calico-${CALICO_VERSION}` file from upstream and port the necessary changes.

> ⚠️ Remember to drop the namespace from the files, becuase it is being added by Kustomize.

3. Update the `kustomization.yaml` file with the right image versions.

```bash
export CALICO_IMAGE_TAG=v3.27.3
kustomize edit set image docker.io/calico/kube-controllers=registry.sighup.io/fury/calico/kube-controllers:${CALICO_IMAGE_TAG}
kustomize edit set image docker.io/calico/cni=registry.sighup.io/fury/calico/cni:${CALICO_IMAGE_TAG}
kustomize edit set image docker.io/calico/node=registry.sighup.io/fury/calico/node:${CALICO_IMAGE_TAG}
```

> ⚠️ Remember to check if images have been added to or dropped from upstream.

4. Update the README.md file.

## Updating monitoring components

The resources needed to provide monitoring features are not included in the default upstream manifests. There are some additional steps to perform.

See <https://docs.tigera.io/calico/latest/operations/monitor/monitor-component-metrics> for details. Note that we are adding an environment variable to the DaemonSet instead of modifing the `default` instance of the `felixconfigurations.crd.projectcalico.org` CRD as the docs say. Modifing the CRD is not possible using Kustomize patches.

1. Download the dashboard from upstream:

```bash
export CALICO_VERSION=3.27.3
# ⚠️ Assuming $PWD == root of the project
# We take the `felix-dashboard.json` from the downloaded yaml, we are not deploying `typha`, so we don't need its dashboard.
curl -L https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/grafana-dashboards.yaml | yq '.data["felix-dashboard.json"]' | sed 's/calico-demo-prometheus/prometheus/g' | jq > ./monitoring/dashboards/felix-dashboard.json
```

### Alerts

Calico / Tigera upstream does not provide a set of Prometheus Rules that we could include, from [their monitoring documentation](https://projectcalico.docs.tigera.io/maintenance/monitor/monitor-component-metrics) here are the available metrics:

- <https://projectcalico.docs.tigera.io/reference/felix/prometheus>
- <https://projectcalico.docs.tigera.io/reference/kube-controllers/prometheus>
- <https://projectcalico.docs.tigera.io/reference/typha/prometheus>

The alerts included are inspired in Platform9's and Sysdig's, see:

- <https://platform9.com/docs/kubernetes/catapult-rules-alarms#calico>
- <https://platform9.com/docs/kubernetes/calico-monitoring>
- <https://docs.sysdig.com/en/docs/sysdig-monitor/monitoring-integrations/application-integrations/calico/>
- <https://docs.sysdig.com/en/docs/sysdig-monitor/monitoring-integrations/application-integrations/calico/#errors>

You can generate a markdown table with the rules to include it in the readme with the following commad:

```bash
 yq e '.spec.groups[] | .rules[] |  "| " + .alert + " | " + (.annotations.summary // "-" | sub("\n",". "))+ " | " + (.annotations.description // "-" | sub("\n",". ")) + " |"' katalog/calico/monitoring/prometheusrules.yaml
```
