""" Rules for creating toolchains for cipd """

QemuToolchainInfo = provider(
    fields = [
        "qemu",
        "script_template",
    ],
    doc = "Qemu information",
)

def _qemu_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        qemu_info = QemuToolchainInfo(
            qemu = ctx.file.qemu,
            script_template = ctx.file.script_template,
        ),
    )
    return [toolchain_info]

qemu_toolchain = rule(
    _qemu_toolchain_impl,
    attrs = {
        "qemu": attr.label(
            doc = "Qemu binary",
            allow_single_file = True,
        ),
        "script_template": attr.label(
            doc = "The wrapper script template.",
            allow_single_file = True,
            default = "@rules_emulation//emulation/internal:qemu_execution_wrapper.sh.tpl",
        ),
    },
)

_ALL_OS = [
    "@platforms//os:android",
    "@platforms//os:freebsd",
    "@platforms//os:ios",
    "@platforms//os:linux",
    "@platforms//os:macos",
    "@platforms//os:nixos",
    "@platforms//os:openbsd",
    "@platforms//os:osx",
    "@platforms//os:qnx",
    "@platforms//os:tvos",
    "@platforms//os:wasi",
    "@platforms//os:watchos",
    "@platforms//os:windows",
]

def create_toolchains():
    """ Generates a matrix of toolchains for Host x Targets """
    qemu_toolchain(
        name = "empty",
        script_template = "//emulation/internal:empty_execution_wrapper.sh.tpl",
    )

    # Create a toolchain that prints an error for any target that has an os.
    # i.e. we support qemu-system* only. Bazel doesn't have
    # target_not_compatible_with.
    for os in _ALL_OS:
        native.toolchain(
            name = "empty_toolchain_" + Label(os).name,
            toolchain = ":empty",
            toolchain_type = ":toolchain_type",
            target_compatible_with = [os],
        )
    QEMU_TARGET_BINARIES = {
        (
            "@platforms//cpu:arm",
            "@platforms//cpu:armv6-m",
            "@platforms//cpu:armv7-m",
            "@platforms//cpu:armv7e-m",
            "@platforms//cpu:armv8-m",
        ): "qemu-system-arm",
        (
            "@platforms//cpu:arm64",
            "@platforms//cpu:arm64_32",
            "@platforms//cpu:arm64e",
            "@platforms//cpu:armv7",
            "@platforms//cpu:armv7k",
        ): "qemu-system-aarch64",
        (
            "@platforms//cpu:x86_64",
            "@platforms//cpu:x86_32",
        ): "qemu-system-x86_64",
    }

    SUPPORTED_HOSTS = {
        "qemu_linux_amd64": [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        "qemu_macos_amd64": [
            "@platforms//os:macos",
            "@platforms//cpu:x86_64",
        ],
    }
    for platform_group, binary_name in QEMU_TARGET_BINARIES.items():
        for platform in platform_group:
            for host, exec_compatible_with in SUPPORTED_HOSTS.items():
                qemu_toolchain(
                    name = "{host}_target_{target_cpu}".format(
                        host = host,
                        target_cpu = Label(platform).name,
                    ),
                    qemu = "@{host}//:bin/{binary_name}".format(
                        host = host,
                        binary_name = binary_name,
                    ),
                    tags = ["manual"],
                )

                native.toolchain(
                    name = "{host}_target_{target_cpu}_toolchain".format(
                        host = host,
                        target_cpu = Label(platform).name,
                    ),
                    exec_compatible_with = exec_compatible_with,
                    target_compatible_with = [
                        "@platforms//os:none",
                        platform,
                    ],
                    toolchain = ":{host}_target_{target_cpu}".format(
                        host = host,
                        target_cpu = Label(platform).name,
                    ),
                    toolchain_type = ":toolchain_type",
                    tags = ["manual"],
                )
