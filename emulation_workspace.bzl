load("@rules_cipd//:cipd_deps.bzl", "cipd_deps")

# Pull in your dependencies from cipd.
load("@rules_cipd//cipd:defs.bzl", "cipd_package")

def emulation_workspace():
    """ Initialise the workspace with emulation rules. """
    cipd_deps()
    if "qemu_linux_amd64" not in native.existing_rules():
        cipd_package(
            name = "qemu_linux_amd64",
            id = "FFZaD9tecL-z0lq2XP_7UqiAaMgRGwXTyvcmkv7XCQcC",
            path = "fuchsia/third_party/qemu/linux-amd64",
        )

    if "qemu_macos_amd64" not in native.existing_rules():
        cipd_package(
            name = "qemu_macos_amd64",
            id = "79L6B9YhuL7uIg_CxwlQcZqLOixVtS2Cctn7dmVg0q4C",
            path = "fuchsia/third_party/qemu/mac-amd64",
        )

def register_emulation_toolchains():
    """ Register the emulation toolchains. """
    native.register_toolchains("@rules_emulation//emulation/qemu:all")
