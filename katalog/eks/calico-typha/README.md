# Calico for EKS

**Calico** is open-source networking and network security solution for containers, virtual machines, and
native host-based workloads. Calico supports a broad range of platforms including Kubernetes, OpenShift, Docker EE,
OpenStack, and bare metal services.
With Calico Typha and Calico Node you can enable Network Policy capabilities on the standard EKS networking.

*Source:* [docs.projectcalico.org](https://docs.projectcalico.org/introduction/).

## Image repository and tag

- calico images:
  - `quay.io/calico/node:v3.13.4`.
  - `quay.io/calico/typha:v3.13.4`.
  - `k8s.gcr.io/cluster-proportional-autoscaler-amd64:1.7.1`

## Requirements

- Tested with Kubernetes >= `1.14.X`.
- Tested with Kustomize = `v3.3.X`.
- Prometheus Operator.

## Deployment

You can deploy calico + typha on your EKS cluster by running the following command in the root of this project:

```shell
kustomize build | kubectl apply -f -
```

## License

For license details please see [LICENSE](./../../LICENSE)
