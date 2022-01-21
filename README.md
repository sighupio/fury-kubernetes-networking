 <img src="https://github.com/sighupio/fury-distribution/blob/master/docs/assets/fury-epta-white.png?raw=true" align="left" width="125" style="margin-right: 15px"/> 

# Fury Kubernetes Networking

![Release](https://img.shields.io/github/v/release/sighupio/fury-kubernetes-networking?label=Module%20Release)
![Release](https://img.shields.io/github/v/release/sighupio/fury-distribution?label=KFD%20Release)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-networking?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<br/>

**Fury Kubernetes Networking** implements in-cluster networking functionality via Container Network Interface (CNI) for the [Kubernetes Fury Distribution (KFD)][kfd-repo].

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Packages

Fury Kubernetes Networking contains the following packages:

|          Package           | Version |                                   Description                                    |
| -------------------------- | ------- | -------------------------------------------------------------------------------- |
| [calico](katalog/calico)   | `3.21`  | [Calico][calico-page] CNI Plugin                                                 |
| [ip-masq](katalog/ip-masq) | `2.5.0` | The `ip-masq-agent` configures iptables rules to implement ip-masq functionality |

> The resources in these packages are going to be deployed in `kube-system` namespace.

Click on each package to see its full documentation.

## Compatibility

| Module Version |      `1.20.x`      |      `1.21.x`      |      `1.22.x`      | `1.23.x`  |
| -------------- | :----------------: | :----------------: | :----------------: | --------- |
| `v1.8`         | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning: |

|             Legend             |
| ------------------------------ |
| :white_check_mark:  Compatible |
| :warning:  Has issues          |
| :x:    Incompatible            |

> :warning: Module version: `v1.8.0` and Kubernetes Version: `1.23.x` should work as expected.
> It is marked as warning because it is not yet officially supported by [SIGHUP][sighup-page].

Check the [compatibility matrix][compatibility-matrix] for additional informations about previous releases of the modules.

## Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-networking/issues/new/choose).

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

## License

This module is open-source software and it's released under the following [LICENSE](LICENSE)

<!-- Links -->
[calico-page]: https://github.com/projectcalico/calico
[sighup-page]: https://sighup.io
[kfd-repo]: https://github.com/sighupio/fury-distribution
[kfd-docs]: https://docs.kubernetesfury.com/docs/distribution/
[compatibility-matrix]: docs/COMPATIBILITY_MATRIX.md
