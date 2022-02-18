#!/bin/bash
echo $1
set -eo pipefail

# Create temporary copy of kernel image and place it in /tmp. Qemu doesn't like
# mounting a read only file to run as a drive.
# TODO: Explore better options for this as large images will be problematic with
# this approach.
img_sha256=$(sha256sum $1 | cut -d ' ' -f 1)
tmpdir=/tmp/bazelembedded/rules_qemu/$img_sha256
mkdir -p $tmpdir
tmp_image=$tmpdir/image.raw
cp $1 $tmp_image
chmod 755 $tmp_image

# Bazel runs the execution wrapper out of the user workspace directory when
# using `bazel run`. But the runs it out of a sandbox when it is run as a test.
# This workaround simply detects if the script is in a test environment.
if [[ -z "$TEST_BINARY" ]]; then
  bazel-{WORKSPACE}/{QEMU} {ARGS} -kernel $1 #-drive file=$tmp_image,format=raw
else
  {QEMU} {ARGS} -drive file=$tmp_image,format=raw
fi

rm -r $tmpdir