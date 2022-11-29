load("@rules_cipd//cipd:defs.bzl", "cipd_package")

def emulation_deps():
    if "qemu_linux_amd64" not in native.existing_rules():
        cipd_package(
            name = "qemu_linux_amd64",
            path = "fuchsia/third_party/qemu/linux-amd64",
            id = "FFZaD9tecL-z0lq2XP_7UqiAaMgRGwXTyvcmkv7XCQcC",
        )
    if "qemu_linux_arm64" not in native.existing_rules():
        cipd_package(
            name = "qemu_linux_arm64",
            path = "fuchsia/third_party/qemu/linux-arm64",
            id = "FFZaD9tecL-z0lq2XP_7UqiAaMgRGwXTyvcmkv7XCQcC",
        )
    if "qemu_mac_amd64" not in native.existing_rules():
        cipd_package(
            name = "qemu_mac_amd64",
            path = "fuchsia/third_party/qemu/mac-amd64",
            id = "79L6B9YhuL7uIg_CxwlQcZqLOixVtS2Cctn7dmVg0q4C",
        )
