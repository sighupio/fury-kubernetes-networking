<!-- markdownlint-disable MD033 -->
<h1>
    <img src="https://github.com/sighupio/fury-distribution/blob/master/docs/assets/fury-epta-white.png?raw=true" align="left" width="90" style="margin-right: 15px"/>
    Kubernetes Fury Networking
</h1>
<!-- markdownlint-enable MD033 -->

![Release](https://img.shields.io/github/v/release/sighupio/fury-kubernetes-networking?label=Latest%20Release)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-networking?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <KFD-DOCS> -->

**Kubernetes Fury Networking** implements in-cluster networking functionality for the [Kubernetes Fury Distribution (KFD)][kfd-repo] via Container Network Interface (CNI) plugins.

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Overview

Kubernetes has adopted the Container Network Interface (CNI) specification for managing network resources on a cluster.

**Kubernetes Fury Networking**  makes use of CNCF recommended [Project Calico](https://www.projectcalico.org/), open-source networking and network security solution for containers, virtual machines, and bare-metal workloads, to bring networking features to the Kubernetes Fury Distribution.

Calico deployment consists of a daemon set running on every node (including control-plane nodes) and a controller.

## Packages

Kubernetes Fury Networking provides the following packages:

| Package                    | Version  | Description                                                                      |
| -------------------------- | -------- | -------------------------------------------------------------------------------- |
| [calico](katalog/calico)   | `3.21.3` | [Calico][calico-page] CNI Plugin. For cluster with `< 50` nodes.                 |
| [ip-masq](katalog/ip-masq) | `2.5.0`  | The `ip-masq-agent` configures iptables rules to implement ip-masq functionality |

> The resources in these packages are going to be deployed in `kube-system` namespace.

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes                                               |
| ------------------ | :----------------: | --------------------------------------------------- |
| `1.20.x`           | :white_check_mark: | No known issues                                     |
| `1.21.x`           | :white_check_mark: | No known issues                                     |
| `1.22.x`           | :white_check_mark: | No known issues                                     |
| `1.23.x`           |     :warning:      | Conformance tests passed. Not officially supported. |

Check the [compatibility matrix][compatibility-matrix] for additional information on previous releases of the module.

## Usage

### Prerequisites

| Tool                        | Version   | Description                                                                                                                                                      |
| --------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.6.0` | The recommended tool to download and manage KFD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].       |
| [kustomize][kustomize-repo] | `>=3.5.0` | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to their [repository][kustomize-repo]. |

### Deployment

> ⚠️ please notice that the Calico packages is for cluster with less the 50 nodes. If your cluster has more than 50 nodes, you'll need to switch to [Calico + Typha](https://projectcalico.docs.tigera.io/archive/v3.23/getting-started/kubernetes/self-managed-onprem/onpremises#install-calico-with-kubernetes-api-datastore-more-than-50-nodes).

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: networking/calico
    version: "v1.8.2"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/networking`.

4. Define a `kustomization.yaml` that includes the `./vendor/katalog/networking` directory as a resource.

```yaml
resources:
- ./vendor/katalog/networking/calico
```

5. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```


<!-- Links -->
[calico-page]: https://github.com/projectcalico/calico
[sighup-page]: https://sighup.io
[kfd-repo]: https://github.com/sighupio/fury-distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kustomize-repo]: https://github.com/kubernetes-sigs/kustomize
[kfd-docs]: https://docs.kubernetesfury.com/docs/distribution/
[compatibility-matrix]: https://github.com/sighupio/fury-kubernetes-networking/blob/master/docs/COMPATIBILITY_MATRIX.md

<!-- </KFD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-networking/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
