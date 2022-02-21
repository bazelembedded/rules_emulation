load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def emulation_deps():
    http_archive(
        name = "rules_cipd",
        sha256 = "b96ad320f82f0c881705ef10e78770a1e20517c7b1925564f858b16e009c30d4",
        urls = [
            "https://github.com/bazelembedded/rules_cipd/releases/download/0.0.1/rules_cipd-0.0.1.tar.gz",
        ],
    )
