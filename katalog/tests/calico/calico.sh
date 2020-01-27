#!/usr/bin/env bats

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
    loop_it test 30 2
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Calico Node is Running" {
    info
    test() {
        kubectl get pods -l k8s-app=calico-node -o json -n kube-system |jq '.items[].status.containerStatuses[].ready' | uniq | grep -q true
    }
    loop_it test 30 2
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
