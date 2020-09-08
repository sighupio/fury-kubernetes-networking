# Fury Kubernetes Networking

## Networking Packages

The following packages are included in the Fury Kubernetes Networking katalog. All
resources in these repositories are going to be deployed in `kube-system`
namespace in your Kubernetes cluster.

- [calico](katalog/calico): Calico for Kubernetes. Calico enables networking and
network policy in Kubernetes clusters across the cloud. Version: **3.16.0**

You can click on each package to see its documentation.

## Compatibility

| Module Version / Kubernetes Version | 1.14.X             | 1.15.X             | 1.16.X             | 1.17.X             | 1.18.X             | 1.19.X             |
|-------------------------------------|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|
| v1.0.0                              |      :warning:     |      :warning:     |      :warning:     |                    |                    |                    |
| v1.0.1                              |      :warning:     |      :warning:     |      :warning:     |                    |                    |                    |
| v1.1.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |
| v1.2.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |
| v1.2.1                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |
| v1.3.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |
| v1.4.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |      :warning:     |

- :white_check_mark: Compatible
- :warning: Has issues
- :x: Incompatible


### Warning

- :warning: : module version: `v1.4.0` and Kubernetes Version: `1.19.x`. It works as expected. Marked as warning
because it is not officially supported by [SIGHUP](https://sighup.io).

## License

For license details please see [LICENSE](LICENSE)
