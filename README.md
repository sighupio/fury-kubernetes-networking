# Fury Kubernetes Networking

##  Networking Packages

Following packages are included in Fury Kubernetes Networking katalog. All
resources in these repositories are going to be deployed in `kube-system`
namespace in your Kubernetes cluster.

- [calico](katalog/calico): Calico for Kubernetes. Calico enables networking and
network policy in Kubernetes clusters across the cloud. Version: **3.6.1**
- [weave-net](katalog/weave-net): Weave Net enables you to get started with
Docker clusters and portable apps in a fraction of the time required
by other solutions. Version: **2.4.1**

You can click on each package to see its documentation.

## Compatibility

| Module Version / Kubernetes Version | 1.14.X             | 1.15.X             | 1.16.X             |
|-------------------------------------|:------------------:|:------------------:|:------------------:|
| v1.0.0                              |      :warning:     |      :warning:     |      :warning:     |
| v1.0.1                              |      :warning:     |      :warning:     |      :warning:     |
| v1.1.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |

- :white_check_mark: Compatible
- :warning: Has issues
- :x: Incompatible


## License

For license details please see [LICENSE](https://sighup.io/fury/license)
