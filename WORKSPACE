workspace(name = "rules_emulation")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Setup documentation generator for Bazel.
# Required by: rules_emulation.
http_archive(
    name = "io_bazel_stardoc",
    sha256 = "c9794dcc8026a30ff67cf7cf91ebe245ca294b20b071845d12c192afe243ad72",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
        "https://github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
    ],
)

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

# Setup starlark libraries for Bazel.
# Required by: rules_emulation.
http_archive(
    name = "bazel_skylib",
    sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "rules_cipd",
    sha256 = "b96ad320f82f0c881705ef10e78770a1e20517c7b1925564f858b16e009c30d4",
    urls = [
        "https://github.com/bazelembedded/rules_cipd/releases/download/0.0.1/rules_cipd-0.0.1.tar.gz",
    ],
)

load("@rules_cipd//:cipd_deps.bzl", "cipd_deps")

cipd_deps()

# Pull in your dependencies from cipd.
load("@rules_cipd//cipd:defs.bzl", "cipd_package")

cipd_package(
    name = "qemu_linux_amd64",
    id = "FFZaD9tecL-z0lq2XP_7UqiAaMgRGwXTyvcmkv7XCQcC",
    path = "fuchsia/third_party/qemu/linux-amd64",
)

cipd_package(
    name = "qemu_macos_amd64",
    id = "79L6B9YhuL7uIg_CxwlQcZqLOixVtS2Cctn7dmVg0q4C",
    path = "fuchsia/third_party/qemu/mac-amd64",
)

register_toolchains("@rules_emulation//emulation/qemu:all")

register_execution_platforms("@rules_emulation//examples/x86_baremetal:x86_64_baremetal")
