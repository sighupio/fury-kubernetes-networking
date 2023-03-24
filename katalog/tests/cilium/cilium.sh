#!/bin/bash
# Copyright (c) 2022 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2154

load ./../helper

@test "Nodes in Not Ready state" {
    info
    nodes_not_ready() {
        kubectl get nodes --no-headers | awk  '{print $2}' | uniq | grep -q NotReady
    }
    run nodes_not_ready
    [ "$status" -eq 0 ]
}

@test "Install Cilium core" {
    info
    install() {
        kubectl apply -f 'https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.1/katalog/prometheus-operator/crds/0servicemonitorCustomResourceDefinition.yaml'
        kubectl apply -f 'https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.1/katalog/prometheus-operator/crds/0prometheusruleCustomResourceDefinition.yaml'
        apply katalog/cilium/core
    }
    run install
    [ "$status" -eq 0 ]
}

@test "Cilium Operator is Running" {
    info
    test() {
        kubectl get pods -l name=cilium-operator -o json -n kube-system |jq '.items[].status.containerStatuses[].ready' | uniq | grep -q true
    }
    loop_it test 60 5
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Cilium is Running" {
    info
    test() {
        kubectl get pods -l k8s-app=cilium -o json -n kube-system |jq '.items[].status.containerStatuses[].ready' | uniq | grep -q true
    }
    loop_it test 60 5
    status=${loop_it_result}
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
