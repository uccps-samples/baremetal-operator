# When bumping the Go version, don't forget to update the configuration of the
# CI jobs in openshift/release.
FROM openshift/golang-builder@sha256:4820580c3368f320581eb9e32cf97aeec179a86c5749753a14ed76410a293d83 AS builder
ENV __doozer=update BUILD_RELEASE=202202160023.p0.g76fd38b.assembly.stream BUILD_VERSION=v4.10.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=10 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.10.0-202202160023.p0.g76fd38b.assembly.stream SOURCE_GIT_TREE_STATE=clean 
ENV __doozer=merge OS_GIT_COMMIT=76fd38b OS_GIT_VERSION=4.10.0-202202160023.p0.g76fd38b.assembly.stream-76fd38b SOURCE_DATE_EPOCH=1643211496 SOURCE_GIT_COMMIT=76fd38be960e6aad3f98b7e645607f96e5bfcd36 SOURCE_GIT_TAG=76fd38b SOURCE_GIT_URL=https://github.com/openshift/cluster-baremetal-operator 
WORKDIR /go/src/github.com/openshift/cluster-baremetal-operator
COPY . .
RUN make cluster-baremetal-operator

FROM openshift/ose-base:v4.10.0.20220216.010142
ENV __doozer=update BUILD_RELEASE=202202160023.p0.g76fd38b.assembly.stream BUILD_VERSION=v4.10.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=10 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.10.0-202202160023.p0.g76fd38b.assembly.stream SOURCE_GIT_TREE_STATE=clean 
ENV __doozer=merge OS_GIT_COMMIT=76fd38b OS_GIT_VERSION=4.10.0-202202160023.p0.g76fd38b.assembly.stream-76fd38b SOURCE_DATE_EPOCH=1643211496 SOURCE_GIT_COMMIT=76fd38be960e6aad3f98b7e645607f96e5bfcd36 SOURCE_GIT_TAG=76fd38b SOURCE_GIT_URL=https://github.com/openshift/cluster-baremetal-operator 
COPY --from=builder /go/src/github.com/openshift/cluster-baremetal-operator/bin/cluster-baremetal-operator /usr/bin/cluster-baremetal-operator
COPY --from=builder /go/src/github.com/openshift/cluster-baremetal-operator/manifests /manifests
ENTRYPOINT ["/usr/bin/cluster-baremetal-operator"]

LABEL \
        io.openshift.release.operator="true" \
        name="openshift/ose-cluster-baremetal-operator" \
        com.redhat.component="ose-cluster-baremetal-operator-container" \
        io.openshift.maintainer.product="OpenShift Container Platform" \
        io.openshift.maintainer.component="Bare Metal Hardware Provisioning" \
        io.openshift.maintainer.subcomponent="cluster-baremetal-operator" \
        release="202202160023.p0.g76fd38b.assembly.stream" \
        io.openshift.build.commit.id="76fd38be960e6aad3f98b7e645607f96e5bfcd36" \
        io.openshift.build.source-location="https://github.com/openshift/cluster-baremetal-operator" \
        io.openshift.build.commit.url="https://github.com/openshift/cluster-baremetal-operator/commit/76fd38be960e6aad3f98b7e645607f96e5bfcd36" \
        version="v4.10.0"

