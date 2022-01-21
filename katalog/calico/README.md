# Calico

**Calico** is open-source networking and network security solution for containers, virtual machines, and native host-based workloads.
Calico supports a broad range of platforms including Kubernetes, OpenShift, Docker EE, OpenStack, and bare metal services.

> For more information about Calico refer to [calico documentation][calico-documentation]

The deployment of Calico consists of a daemon set running on every node (including control-plane) and a controller that implements:

- *policy controller* watches network policies and programs Calico policies.
- *namespace controller* watches namespaces and programs Calico profiles.
- *serviceaccount controller* watches service accounts and programs Calico profiles.
- *workloadendpoint controller* watches for changes to pod labels and updates Calico workload endpoints.
- *node controller* watches for the removal of Kubernetes nodes and removes corresponding data from Calico.

## Image repository and tag

- calico images:
  - `calico/kube-controllers:v3.19.1`.
  - `calico/cni:v3.19.1`.
  - `calico/pod2daemon-flexvol:v3.19.1`.
  - `calico/node:v3.19.1`.
- calico repositories:
  - [https://github.com/projectcalico/kube-controllers](https://github.com/projectcalico/kube-controllers).
  - [https://github.com/projectcalico/cni-plugin](https://github.com/projectcalico/cni-plugin).
  - [https://github.com/projectcalico/pod2daemon](https://github.com/projectcalico/pod2daemon).
  - [https://github.com/projectcalico/node](https://github.com/projectcalico/node).

## Requirements

- Tested with Kubernetes >= `1.18.X`.
- Tested with Kustomize = `v3.3.X`.
- Prometheus Operator.

## Configuration

Fury distribution calico package is deployed with the following configuration:

- Default overlay pod CIDR: `172.16.0.0/16`.
- Default MTU Size: `1440`.
- BGP `(bird)` mode configured instead of `vxlan`.
- [`kubernetes` datastore](https://docs.projectcalico.org/getting-started/kubernetes/hardway/the-calico-datastore#using-kubernetes-as-the-datastore).
- Enable support for [traffic shaping](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/#support-traffic-shaping).
- ServiceMonitor *(Prometheus Operator)* configured to scrape metrics every 15 seconds.

## Deployment

You can deploy calico by running the following command in the root of this project:

```shell
kustomize build | kubectl apply -f -
```

## License

For license details please see [LICENSE](./../../LICENSE)

[calico-documentation]: (docs.projectcalico.org)

