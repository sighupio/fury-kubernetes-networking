# Calico

<!-- <KFD-DOCS> -->

**Calico** is open-source networking and network security solution for containers, virtual machines, and native host-based workloads.
Calico supports a broad range of platforms including Kubernetes, OpenShift, Docker EE, OpenStack, and bare metal services.

> For more information about Calico refer to [calico documentation][calico-documentation]

The deployment of Calico consists of a daemon set running on every node (including the control-plane) and a controller that implements:

- *policy controller* watches network policies and programs Calico policies.
- *namespace controller* watches namespaces and programs Calico profiles.
- *serviceaccount controller* watches service accounts and programs Calico profiles.
- *workloadendpoint controller* watches for changes to pod labels and updates Calico workload endpoints.
- *node controller* watches for the removal of Kubernetes nodes and removes corresponding data from Calico.

> ⚠️ please notice that the Calico packages is for cluster with less the 50 nodes. If your cluster has more than 50 nodes, you'll need to switch to [Calico + Typha](https://projectcalico.docs.tigera.io/archive/v3.23/getting-started/kubernetes/self-managed-onprem/onpremises#install-calico-with-kubernetes-api-datastore-more-than-50-nodes).

## Image repository and tag

- calico images:
  - `calico/kube-controllers:v3.21.3`.
  - `calico/cni:v3.21.3`.
  - `calico/pod2daemon-flexvol:v3.21.3`.
  - `calico/node:v3.21.3`.
- calico repositories:
  - [https://github.com/projectcalico/kube-controllers](https://github.com/projectcalico/kube-controllers).
  - [https://github.com/projectcalico/cni-plugin](https://github.com/projectcalico/cni-plugin).
  - [https://github.com/projectcalico/pod2daemon](https://github.com/projectcalico/pod2daemon).
  - [https://github.com/projectcalico/node](https://github.com/projectcalico/node).

## Requirements

- Tested with Kubernetes >= `1.20.X`.
- Tested with Kustomize >= `v3.3.X`.
- Prometheus Operator, optional if you want to have metrics.

## Configuration

The calico package is deployed with the following configuration:

- Default overlay pod CIDR: detected automatically for `kubeadm` based clusters.
- Default MTU Size: `1440`.
- BGP `(bird)` mode configured instead of `vxlan`.
- [`kubernetes` datastore](https://docs.projectcalico.org/getting-started/kubernetes/hardway/the-calico-datastore#using-kubernetes-as-the-datastore).
- Enable support for [traffic shaping](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/#support-traffic-shaping).
- ServiceMonitor (Prometheus Operator) configured to scrape metrics every 15 seconds.

## Deployment

You can deploy calico by running the following command in the root of this project:

```shell
kustomize build | kubectl apply -f -
```

<!-- LINKS -->
[calico-documentation]: https://projectcalico.docs.tigera.io/about/about-calico

<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](./../../LICENSE)
