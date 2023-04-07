# Cilium

<!-- <KFD-DOCS> -->

**Cilium** is an open source, cloud native solution for providing, securing, and observing network connectivity between
workloads, fueled by the revolutionary Kernel technology eBPF.

> For more information about Cilium refer to [cilium documentation][cilium-documentation]

The deployment of Cilium consists of a DaemonSet running on all nodes, and a operator Deployment.
Additionally, we deploy hubble component as an observability tool on the network connections between pods in the cluster.

> ⚠️ please notice that the Cilium package is for cluster with less than 200 nodes.

## Image repository and tag

- cilium images:
  - `registry.sighup.io/fury/cilium/cilium:v1.13.1`
  - `registry.sighup.io/fury/cilium/operator-generic:v1.13.1`
  - `registry.sighup.io/fury/cilium/hubble-ui-backend:v0.10.0`
  - `registry.sighup.io/fury/cilium/hubble-ui:v0.10.0`
  - `registry.sighup.io/fury/cilium/hubble-relay:v1.13.1`

## Requirements

- Kubernetes >= `1.23.X`.
- Kustomize >= `v3.5.3`.
- [prometheus-operator from KFD monitoring module][prometheus-operator]
- [cert-manager from KFD ingress module][cert-manager]

## Configuration

The Cilium package is deployed with the following configuration:

- TBD

## Deployment

You can deploy Cilium by running the following command in the root of this package:

```bash
kustomize build . | kubectl apply -f -
```

If you want to install Cilium without hubble, use the following command from the root of this package:

```bash
kustomize build core | kubectl apply -f -
```

<!-- LINKS -->
[cilium-documentation]: https://docs.cilium.io/en/stable/
[prometheus-operator]: https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/katalog/prometheus-operator
[cert-manager]: https://github.com/sighup-io/fury-kubernetes-ingress/blob/master/katalog/cert-manager

<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](./../../LICENSE)
