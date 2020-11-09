# IP Masq

IP masquerading is a form of network address translation (NAT) used to perform many-to-one IP address translations,
which allows multiple clients to access a destination using a single IP address. A cluster uses IP masquerading so
that destinations outside of the cluster only receive packets from node IP addresses instead of Pod IP addresses.
This is useful in environments that expect to only receive packets from node IP addresses.

*Source: [https://cloud.google.com/kubernetes-engine/docs](https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent#create_manual)*


## Image repository and tag

- `ip-masq` image:
  - `gcr.io/google-containers/ip-masq-agent-amd64:v2.5.0`.
- `ip-masq` repository:
  - [https://github.com/kubernetes-sigs/ip-masq-agent](https://github.com/kubernetes-sigs/ip-masq-agent).

## Requirements

- Tested with Kubernetes >= `1.16.X`.
- Tested with Kustomize = `v3.3.X`.

## Configuration

Fury distribution ip-masq package is deployed with the following configuration:
- `nonMasqueradeCIDRs`: as an empty list.
- `resyncInterval`: set to 60 seconds.
- `masqLinkLocal`: set to false.
- `masqLinkLocalIPv6`: set to false.

*Available configuration parameters listed here:*
[https://github.com/kubernetes-sigs/ip-masq-agent#configuring-the-agent](https://github.com/kubernetes-sigs/ip-masq-agent#configuring-the-agent)

Also, the design of this `kustomize` project makes it possible to extend the container arguments adding, as an example
the `--nomasq-all-reserved-ranges` flag used to non-masquerade reserved IP ranges by default.

*Available flags listed here:*
[https://github.com/kubernetes-sigs/ip-masq-agent#agent-flags](https://github.com/kubernetes-sigs/ip-masq-agent#agent-flags)

### Important note

You should not attempt to run this agent in a cluster where the Kubelet is also configuring a non-masquerade CIDR.
You can pass --non-masquerade-cidr=0.0.0.0/0 to the Kubelet to nullify its rule, which will prevent the Kubelet from
interfering with this agent.

## Deployment

You can deploy `ip-masq` with the default configuration by running the following command in the root of this project:

```shell
kustomize build | kubectl apply -f -
```

## License

For license details please see [LICENSE](./../../LICENSE)
