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

The on-prem resources file from upstream has been edited to use SIGHUP's registry and deleted the rest of the configuration included upstream. The Operator should detect the CIDR from the cluster's installation and set it accordingly.

## EKS Policy-only mode

The policy only mode definition YAML is taken from EKS documentation:
<https://docs.aws.amazon.com/eks/latest/userguide/calico.html>

Notice that the manifests are not maintained anymore by AWS.

The definition file has been downloaded from:
<https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-crs.yaml>
