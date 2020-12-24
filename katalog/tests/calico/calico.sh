#!/bin/bash
# Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2154

load ./../helper

@test "Nodes in not ready State" {
    info
    test() {
        kubectl get nodes --no-headers | awk  '{print $2}' | uniq | grep -q NotReady
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Install Calico" {
    info
    install() {
        kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v1.10.3/katalog/prometheus-operator/crd-servicemonitor.yml
        apply katalog/calico
    }
    run install
    [ "$status" -eq 0 ]
}

@test "Calico Kube Controller is Running" {
    info
    test() {
        kubectl get pods -l k8s-app=calico-kube-controllers -o json -n kube-system |jq '.items[].status.containerStatuses[].ready' | uniq | grep -q true
    }
    loop_it test 60 5
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Calico Node is Running" {
    info
    test() {
        kubectl get pods -l k8s-app=calico-node -o json -n kube-system |jq '.items[].status.containerStatuses[].ready' | uniq | grep -q true
    }
    loop_it test 60 5
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Calico is exposing metrics" {
    info
    test() {
        kubectl apply -f katalog/tests/calico/resources/test-metrics-job.yaml
        kubectl wait --for=condition=complete job/test-metrics --timeout=15s
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Nodes in ready State" {
    info
    test() {
        kubectl get nodes --no-headers | awk  '{print $2}' | uniq | grep -q Ready
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Apply whitelist-system-ns GlobalNetworkPolicy" {
    info
    install() {
        kubectl apply -f examples/globalnetworkpolicies/1.whitelist-system-namespace.yml
    }
    run install
    [ "$status" -eq 0 ]
}

@test "Create a non-whitelisted namespace with an app" {
    info
    install() {
        kubectl create ns test-1
        kubectl apply -f katalog/tests/calico/resources/echo-server.yaml -n test-1
        kubectl wait -n test-1 --for=condition=ready --timeout=120s pod -l app=echoserver
    }
    run install
    [ "$status" -eq 0 ]
}

@test "Test app within the same namespace" {
    info
    test() {
        kubectl create job -n test-1 isolated-test --image travelping/nettools -- curl http://echoserver.test-1.svc.cluster.local
        kubectl wait -n test-1 --for=condition=complete --timeout=30s job/isolated-test
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Test app from a system namespace" {
    info
    test() {
        kubectl create job -n kube-system isolated-test --image travelping/nettools -- curl http://echoserver.test-1.svc.cluster.local
        kubectl wait -n kube-system --for=condition=complete --timeout=30s job/isolated-test
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Test app from a different namespace" {
    info
    test() {
        kubectl create ns test-1-1
        kubectl create job -n test-1-1 isolated-test --image travelping/nettools -- curl http://echoserver.test-1.svc.cluster.local
        kubectl wait -n test-1-1 --for=condition=complete --timeout=30s job/isolated-test
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Apply deny-all GlobalNetworkPolicy" {
    info
    install() {
        kubectl apply -f examples/globalnetworkpolicies/2000.deny-all.yml
    }
    run install
    [ "$status" -eq 0 ]
}

@test "Test app from the same namespace (isolated namespace)" {
    info
    test() {
        kubectl create job -n test-1 isolated-test-1 --image travelping/nettools -- curl http://echoserver.test-1.svc.cluster.local
        kubectl wait -n test-1 --for=condition=complete --timeout=30s job/isolated-test-1
    }
    run test
    [ "$status" -eq 1 ]
}

@test "Test app from a system namespace (isolated namespace)" {
    info
    test() {
        kubectl create job -n kube-system isolated-test-1 --image travelping/nettools -- curl http://echoserver.test-1.svc.cluster.local
        kubectl wait -n kube-system --for=condition=complete --timeout=30s job/isolated-test-1
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Test app from a different namespace (isolated namespace)" {
    info
    test() {
        kubectl create job -n test-1-1 isolated-test-1 --image travelping/nettools -- curl http://echoserver.test-1.svc.cluster.local
        kubectl wait -n test-1-1 --for=condition=complete --timeout=30s job/isolated-test-1
    }
    run test
    [ "$status" -eq 1 ]
}
