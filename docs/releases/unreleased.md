# Networking Core Module Release vTBD

Welcome to the latest release of the `Networking` module of [`Kubernetes Fury Distribution`](https://github.com/sighupio/fury-distribution) maintained by team SIGHUP.

## Important changes ℹ️

- [[#87](https://github.com/sighupio/fury-kubernetes-networking/pull/87)] Changed the duration for Cilium's mTLS self-signed CA certificate to 10 years. See the update guide for more information.

## Component Images 🚢

| Component         | Supported Version                                                                | Previous Version |
| ----------------- | -------------------------------------------------------------------------------- | ---------------- |
| `cilium`          | [`v1.16.3`](https://github.com/cilium/cilium/releases/tag/v1.15.2)               | No update        |
| `ip-masq`         | [`v2.8.0`](https://github.com/kubernetes-sigs/ip-masq-agent/releases/tag/v2.8.0) | No update        |
| `tigera-operator` | [`v1.36.1`](https://github.com/tigera/operator/releases/tag/v1.36.1)             | No update        |

> Please refer the individual release notes to get detailed information on each release.

## Breaking Changes 💔

- None

## Update Guide 🦮

### Process

1. Just deploy as usual:

```bash
kustomize build katalog/tigera/on-prem | kubectl apply --server-side -f -
# OR
kustomize build katalog/cilium | kubectl apply --server-side -f -
```

2. (Cilium only) After applying the new version, you will need to manually trigger the renewal of the mTLS certificates for Cilium:

```bash
cmctl renew -n kube-system hubble-relay-client-certs
cmctl renew -n kube-system hubble-server-certs
```

Note: you will need cert-manager's CLI [`cmctl`](https://cert-manager.io/docs/reference/cmctl/) installed.
