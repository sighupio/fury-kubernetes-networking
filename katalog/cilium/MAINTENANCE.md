# Cilium Package Maintenance Guide

```bash
helm pull cilium/cilium --version 1.13.0 --untar --untardir /tmp

# before running helm template, remove from the /tmp/cilium/templates/validation.yaml the ServiceMonitor capability check
helm template cilium /tmp/cilium --namespace kube-system --values MAINTENANCE.values.yaml > built-with-hubble.yaml
helm template cilium /tmp/cilium --namespace kube-system --values MAINTENANCE.values.yaml \
  --set hubble.enabled=false \
  --set hubble.relay.enabled=false \
  --set hubble.ui.enabled=false > built-with-hubble.yaml
```

