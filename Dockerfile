FROM openshift/golang-builder@sha256:4820580c3368f320581eb9e32cf97aeec179a86c5749753a14ed76410a293d83 AS builder
ENV __doozer=update BUILD_RELEASE=202202160023.p0.g28771f4.assembly.stream BUILD_VERSION=v4.10.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=10 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.10.0-202202160023.p0.g28771f4.assembly.stream SOURCE_GIT_TREE_STATE=clean 
ENV __doozer=merge OS_GIT_COMMIT=28771f4 OS_GIT_VERSION=4.10.0-202202160023.p0.g28771f4.assembly.stream-28771f4 SOURCE_DATE_EPOCH=1643362924 SOURCE_GIT_COMMIT=28771f489634da2364fb46766953f2e1962bf350 SOURCE_GIT_TAG=28771f48 SOURCE_GIT_URL=https://github.com/openshift/baremetal-operator 
WORKDIR /go/src/github.com/metal3-io/baremetal-operator
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o bin/baremetal-operator main.go
RUN make tools
RUN make tools/bin/kustomize

RUN cp /go/src/github.com/metal3-io/baremetal-operator/config/crd/ocp/ocp_kustomization.yaml /go/src/github.com/metal3-io/baremetal-operator/config/crd/kustomization.yaml &&\
    tools/bin/kustomize build config/crd > config/crd/baremetalhost.crd.yaml &&\
    mkdir /go/src/github.com/metal3-io/baremetal-operator/manifests &&\
    cp /go/src/github.com/metal3-io/baremetal-operator/config/crd/baremetalhost.crd.yaml /go/src/github.com/metal3-io/baremetal-operator/manifests/0000_30_baremetal-operator_01_baremetalhost.crd.yaml

FROM openshift/ose-base:v4.10.0.20220216.010142
ENV __doozer=update BUILD_RELEASE=202202160023.p0.g28771f4.assembly.stream BUILD_VERSION=v4.10.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=10 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.10.0-202202160023.p0.g28771f4.assembly.stream SOURCE_GIT_TREE_STATE=clean 
ENV __doozer=merge OS_GIT_COMMIT=28771f4 OS_GIT_VERSION=4.10.0-202202160023.p0.g28771f4.assembly.stream-28771f4 SOURCE_DATE_EPOCH=1643362924 SOURCE_GIT_COMMIT=28771f489634da2364fb46766953f2e1962bf350 SOURCE_GIT_TAG=28771f48 SOURCE_GIT_URL=https://github.com/openshift/baremetal-operator 
COPY --from=builder /go/src/github.com/metal3-io/baremetal-operator/bin/baremetal-operator /
COPY --from=builder /go/src/github.com/metal3-io/baremetal-operator/bin/get-hardware-details /
COPY --from=builder /go/src/github.com/metal3-io/baremetal-operator/bin/make-bm-worker /
COPY --from=builder /go/src/github.com/metal3-io/baremetal-operator/bin/make-virt-host /
COPY --from=builder /go/src/github.com/metal3-io/baremetal-operator/manifests /manifests

LABEL \
        io.openshift.release.operator="true" \
        name="openshift/ose-baremetal-operator" \
        com.redhat.component="ose-baremetal-operator-container" \
        io.openshift.maintainer.product="OpenShift Container Platform" \
        io.openshift.maintainer.component="Bare Metal Hardware Provisioning" \
        io.openshift.maintainer.subcomponent="baremetal-operator" \
        release="202202160023.p0.g28771f4.assembly.stream" \
        io.openshift.build.commit.id="28771f489634da2364fb46766953f2e1962bf350" \
        io.openshift.build.source-location="https://github.com/openshift/baremetal-operator" \
        io.openshift.build.commit.url="https://github.com/openshift/baremetal-operator/commit/28771f489634da2364fb46766953f2e1962bf350" \
        version="v4.10.0"

