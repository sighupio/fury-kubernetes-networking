# Global network policies to harden cluster network security

This folder contains some baseline global network policies to enforce the best practice of
default deny network policy. This way, pods without policy (or incorrect policy) are 
not allowed traffic until appropriate network policy is defined.

The policies in this folder are **ORDERED**. This means that the policy with the lowest order number (lowest = 1) is evaluated first.

### Index
- [Base policies](#base-policies-explanation)
    - [1. Whitelist system namespaces](#1-whitelist-system-namespaces)
    - [2000. Deny All](#2000-deny-all)
- [Namespaces policies](#namespaces-policies)
    - [401. Allow custom cidr from namespaces](#401-allow-custom-cidr-from-namespaces)
    - [1000. Allow intra namespaces communication](#1000-allow-intra-namespaces-communication)
- [Caveats - No, really, you MUST read this](#caveats-no-really-you-must-read-this)
    - [500. Control plane traffic](#500-control-plane-traffic)



## Base policies explanation

### 1. Whitelist system namespaces

```yaml
apiVersion: crd.projectcalico.org/v1
kind: GlobalNetworkPolicy
metadata:
  name: whitelist-system-ns
spec:
  order: 1
  selector: projectcalico.org/namespace in {'default', 'ingress-nginx', 'istio-system', 'kube-system', 'logging', 'monitoring', 'registry','gatekeeper-system','cert-manager'}
  types:
    - Ingress
    - Egress
  ingress:
    - action: Allow
  egress:
    - action: Allow
```

This first policy allows all traffic on the system namespaces. Admins always control the system namespaces,
no need to deny traffic.

This policy has order **1**.

### 2000. Deny All

```yaml
apiVersion: crd.projectcalico.org/v1
kind: GlobalNetworkPolicy
metadata:
  name: deny-all
spec:
  order: 2000
  selector: projectcalico.org/namespace not in {'default', 'ingress-nginx', 'istio-system', 'kube-system', 'logging', 'monitoring', 'registry','gatekeeper-system','cert-manager'}
  ingress:
    - action: Allow
      source:
        namespaceSelector: projectcalico.org/name in {'default', 'ingress-nginx', 'istio-system', 'kube-system', 'logging', 'monitoring', 'registry','gatekeeper-system','cert-manager'}
  egress:
    - action: Allow # System namespace traffic
      destination:
        namespaceSelector: projectcalico.org/name in {'default', 'ingress-nginx', 'kube-system', 'istio-system', 'monitoring'}

  types:
    - Ingress
    - Egress
```

While allowing all the system namespaces, we need also to allow all other namespaces to talk with system ones. This enables 
ingress controllers traffic, Apiserver traffic, and so on. This policy, having only the traffic between non-system namespaces and
system namespaces enabled, disallows all other traffic, thus achieving DENY ALL.

## Namespaces Policies

Now that all the traffic is denied, we need to open some defaults. The first baseline globalnetworkpolicies we need are:

- Open traffic between namespaces with the same label.
- Open egress traffic on defined namespaces.

This can be achieved by adding other network policies by ordering between 1 and 2000.

### 401. Allow custom cidr from namespaces

```yaml
apiVersion: crd.projectcalico.org/v1
kind: GlobalNetworkPolicy
metadata:
  name: allow-custom-cidr-from-sighup
spec:
  order: 401
  selector: projectcalico.org/namespace in {'sighup'}
  egress:
    - action: Allow
      destination:
        nets:
          - 1.2.3.4/32
  types:
    - Egress
```

This policy enables Egress traffic to 1.2.3.4/32 on all the workloads in the namespace `sighup`. The order is 401 as we stated 
before, to be between the allow system namespace policy and the deny all policy.

### 1000. Allow intra namespaces communication

```yaml
apiVersion: crd.projectcalico.org/v1
kind: GlobalNetworkPolicy
metadata:
  name: sighup-intra-allow
spec:
  order: 1000
  namespaceSelector: 'tenant == "sighup"'
  ingress:
    - action: Allow
      source:
        namespaceSelector: 'tenant == "sighup"'
  egress:
    - action: Allow
      destination:
        namespaceSelector: 'tenant == "sighup"'
```

This policy enables traffic between all the namespaces with the label `tenant=sighup`. So if we have more than one namespaces that need to talk
is sufficient to set the correct label, and the traffic will be allowed.

## Caveats - No, really, you MUST read this

In this section, you'll find all the relevant informations to enable additional behavior using network policies.

### 500. Control plane traffic

```yaml
apiVersion: crd.projectcalico.org/v1
kind: GlobalNetworkPolicy
metadata:
  name: whitelist-control-plane
spec:
  order: 500
  selector: projectcalico.org/namespace not in {'default', 'ingress-nginx', 'istio-system', 'kube-system', 'logging', 'monitoring', 'registry','gatekeeper-system','cert-manager'}
  egress:
    - action: Allow
      destination:
        nets:
          - 172.16.0.3/32 # you apiserver ips list
  types:
    - Egress
```

If you need to grant access to `kubernetes.default` (the apiserver) you need to add another rule to open egress traffic to apiserver ips.

This is needed if your workloads needs to talk with the Apiserver. By default this rule enables traffic for all the non system namespaces, but you can create custom rules
to allow traffic only from one namespace.