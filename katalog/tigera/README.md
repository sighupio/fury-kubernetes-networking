# Tigera Package

The Tigera package provides the Tigera Operator and some ready to go configurations to enable Networking capabilities for a Kubernetes cluster.

## Tigera Operator

The Tigera Operator is an **alternative** to the [Calico](../calico) manifests package. It provides CNI and networking capabilities to a Kubernetes cluster.

### On-premises installation

To install the Tigera operator in an empty on-premises cluster run the following command:

1. Deploy the `on-prem` package, it will deploy both the Operator and the configuration:

```bash
kustomize build katalog/tigera/on-prem | kubectl apply -f - --server-side
```

If you would like customize the installation, patch the `tigera/on-prem/custom-resources.yaml` your desired configuration. See the [official documentation](https://projectcalico.docs.tigera.io/getting-started/kubernetes/installation/config-options) for details.

#### Migrating from Calico manifests to the Tigera Operator

To migrate from a manifests installation to the Tigera operator the high-level steps are:

1. Install the `on-prem` version:

```bash
kustomize build katalog/tigera/on-prem | kubectl apply -f - --server-side
```

2. The operator will adopt the existing resources and migrate them to the `calico-system` namespace.

Please refer to Calico's documentation for more details:
<https://projectcalico.docs.tigera.io/maintenance/operator-migration>

> ⚠️ If you were using "**Infra**" nodes, you'll need to patch the `Install` resource with the right `NodeSelector` and `Tolerations`.
> For example with the following Kustomize `patchesStrategicMerge`:
>
> ```yaml
> ---
> apiVersion: operator.tigera.io/v1
> kind: Installation
> metadata:
>   name: default
> spec:
>   controlPlaneNodeSelector:
>     node.kubernetes.io/role: "infra"
>   controlPlaneTolerations:
>     - key: node.kubernetes.io/role
>       value: infra
>       operator: Equal
>       effect: NoSchedule
> ```

The Operator moves Calico's pods from the `kube-system` namespace to the `calico-namespace`. As part of the `on-prem` variant, you are provided with the new resources (`Services` and `ServiceMonitors`) to keep the monitoring working in the new namespace.

You might want to delete the old and unneeded `Services` and `ServiceMonitors` remaining in the `kube-system` namespace:

```bash
kubectl delete service -n kube-system calico-node felix-metrics-svc kube-controllers-metrics-svc
kubectl delete servicemonitors.monitoring.coreos.com -n kube-system calico-node
```

### EKS Policy-only mode installation

The `eks-policy-mode` package is used run the Tigera Operator for enforcing network policies -and not as CNI- in a EKS cluster.

The policy only mode will install the operator and configure it to not enable the CNI features.

To install it run the following command:

```bash
kustomize build katalog/tigera/policy-only | kubectl apply -f - --server-side
```

> Note that you can also completely replace the AWS CNI with Calico if you need to:
> <https://projectcalico.docs.tigera.io/getting-started/kubernetes/managed-public-cloud/eks>
