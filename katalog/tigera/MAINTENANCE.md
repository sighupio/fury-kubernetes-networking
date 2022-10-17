# Tigera Package Maintenance Guide

## Tigera Operator

Tigera operator manifests files are taken as-is from upstream.

Here are the installation notes:
<https://projectcalico.docs.tigera.io/getting-started/kubernetes/self-managed-onprem/onpremises>

To update the YAML file, run the following command:

```bash
# assuming $PWD is the root of the repository
export CALICO_VERSION="3.24.1"
curl "https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/tigera-operator.yaml" --output katalog/tigera/operator/tigera-operator.yaml
```

No customizations are made.

## On-prem

For managed on-prem installations, in addition to the operator you need to create a custom resource with the CNI configuration.

Here is the documentation
<https://projectcalico.docs.tigera.io/getting-started/kubernetes/self-managed-onprem/onpremises>

To download the default configuration from upstram and update the file use the following commands:

```bash
# assuming $PWD is the root of the repository
export CALICO_VERSION="3.24.1"
curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/custom-resources.yaml -O katalog/tigera/on-prem/custom-resources.yaml
```

### Customizations

The on-prem resources file from upstream has been edited with the following:

- Use SIGHUP's registry
- Deleted the `calicoNetwork` section included in the upstream configuration file, the Operator should detect the CIDR from the cluster's installation and set it accordingly.
- Calico ApiServer is not deployed by default by our installation.

### Monitoring

There are some custom headless services and service monitors defined as part of the kustomize prject for the on-prem variant.

The dashbaords are the official ones with some minor tuning.

To get the dashboards you can use the following commands:

```bash
# ⚠️ Assuming $PWD == root of the project
export CALICO_VERSION=3.24
# we split the upstream file and store only the json files
curl https://projectcalico.docs.tigera.io/archive/v${CALICO_VERSION}/manifests/grafana-dashboards.yaml | yq '.data["felix-dashboard.json"]' | sed 's/calico-demo-prometheus/prometheus/g' | jq > ./katalog/tigera/on-prem/monitoring/dashboards/felix-dashboard.json
curl https://projectcalico.docs.tigera.io/archive/v${CALICO_VERSION}/manifests/grafana-dashboards.yaml | yq '.data["typha-dashboard.json"]' | sed 's/calico-demo-prometheus/prometheus/g' | jq > ./katalog/tigera/on-prem/monitoring/dashboards/typa-dashboard.json
```

## EKS Policy-only mode

The policy only mode definition YAML is taken from EKS documentation:
<https://docs.aws.amazon.com/eks/latest/userguide/calico.html>

Notice that the manifests are not maintained anymore by AWS.

The definition file has been downloaded from:
<https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-crs.yaml>
