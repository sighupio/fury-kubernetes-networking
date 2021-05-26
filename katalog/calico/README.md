# Calico

**Calico** is open-source networking and network security solution for containers, virtual machines, and
native host-based workloads. Calico supports a broad range of platforms including Kubernetes, OpenShift, Docker EE,
OpenStack, and bare metal services.

*Source:* [docs.projectcalico.org](https://docs.projectcalico.org/introduction/).

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

- Tested with Kubernetes >= `1.14.X`.
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
