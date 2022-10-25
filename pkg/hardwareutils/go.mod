module github.com/metal3-io/baremetal-operator/pkg/hardwareutils

go 1.17

require github.com/pkg/errors v0.9.1

replace (
	golang.org/x/net => github.com/orangeji11/net v0.0.0-20211025121252-0f184d88fbae
	golang.org/x/sys => github.com/loongson/sys v0.0.0-20211022032851-442ec7e848c8
)
