#!/usr/bin/env bash

MODE=${1:-apply}
TAG=1.26-alpha.6eb9df42ed4ba446d4a38e8ec5d2e242ad4deb97
HUB=gcr.io/istio-testing

if [[ "$MODE" == "apply" ]]; then
    helm upgrade -i istio-base oci://$HUB/charts/base --version $TAG -n istio-system --create-namespace
    helm upgrade -i istiod oci://$HUB/charts/istiod --version $TAG -n istio-system --set tag=$TAG --set hub=$HUB --wait
else
  helm uninstall istiod --ignore-not-found --namespace istio-system || true
  helm uninstall istio-base --ignore-not-found --namespace istio-system || true
  helm template istio-base oci://$HUB/charts/base --version $TAG -n istio-system | kubectl delete -f - --ignore-not-found
fi
