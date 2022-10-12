# ip-masq-agent Maintenance Guide

`ip-masq-agent` is taken from <https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent#create_manual>

Upstream for the DaemonSet definition is found here:
<https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent#deploy-ip-masq-agent-deamonset>

> 💡 NOTE
>
> The DaemonSet manifest in Google's documentation differs from the one in the GitHub repository.

## Customizations

- Deleted the namespace from the manifests because it is being set by Kustomize.
- The DaemonSet gets patched to use the image from our registry via Kustomize.
- Changed image tag from 2.7.0 to 2.8.0 because the [2.7.0 build has some issues](https://github.com/kubernetes-sigs/ip-masq-agent/releases).
