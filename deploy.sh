#!/bin/bash

VERSION=v1.5.3

# IMPORTANT: this must match the chart version at `$CHART_PATH/Chart.yaml`
CHART_VERSION=0.2.3
CHART=fianu
CHART_PATH=charts/openfga
CHART_NAME=openfga
NAME=openfga
NAMESPACE=openfga

deploy() {
    helm package $CHART_PATH --version $CHART_VERSION --app-version $VERSION

    helm gcs push "$NAME-$CHART_VERSION.tgz" $CHART  --force=true

    rm -f "$NAME-$CHART_VERSION.tgz"

    sleep 5

    helm repo update $CHART

    helm upgrade $NAME "$CHART/$NAME" --install --set image.tag=$VERSION -n $NAMESPACE
}

deploy_dev() {
    helm package $CHART_PATH --version $CHART_VERSION --app-version $VERSION

    helm gcs push "$NAME-$CHART_VERSION.tgz" "$CHART-dev" --force=true

    rm -rf "$NAME-$CHART_VERSION.tgz"

    sleep 5

    helm repo update "$CHART-dev"
}

deploy
deploy_dev

