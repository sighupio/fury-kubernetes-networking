# Networking Core Module version TBD

In this release some changes were added:

## Changelog

- Add [ip-masq package](../../katalog/ip-masq) to the module.
  - Add [an example](../../examples/configure-ip-masq) to fine configure it.

## Upgrade path

To upgrade this core module from `v1.4.0` to `TBD`, you need to download this new version, then apply the
`kustomize` project. No further action is required.

```bash
kustomize build katalog/ip-masq | kubectl apply -f -
```
