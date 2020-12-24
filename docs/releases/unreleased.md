# Networking Core Module version v1.5.0

In this release some changes were added:

## Changelog

- Add [ip-masq package](../../katalog/ip-masq) to the module.
  - Add [an example](../../examples/configure-ip-masq) to fine configure it.
- Upgrade [calico](../../katalog/calico) CNI. From 3.16.1 to 3.17.1.
- Deprecate Kubernetes 1.16 support.
- Kubernetes 1.19 is considered stable.
- Add tech-preview support to Kubernete 1.20.

## Upgrade path

To upgrade this core module from `v1.4.0` to `v1.5.0`, you need to download this new version, then apply the
`kustomize` project. No further action is required.

```bash
kustomize build katalog/ip-masq | kubectl apply -f -
```
