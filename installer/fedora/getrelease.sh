#!/bin/sh -e
# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

USAGE="${0##*/} -a|-r /path/to/chroot

Detects the release (-r) or arch (-a) of the chroot and prints it on stdout.
Fails with an error code of 1 if the chroot does not belong to this distro."

# Get the OS release
rel="`sed -n -e 's/^ID=//p' "${2%/}/etc/os-release"`"

# Print the architecture if requested
if [ "$1" = '-a' ]; then
    cat /etc/yum/vars/basearch 2>/dev/null
else
    echo "$rel"
fi

exit 0
