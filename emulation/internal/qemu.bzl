_BAZEL_TO_QEMU_CPU = {
    "@platforms//cpu:armv6-m": "cortex-m0",
    "@platforms//cpu:armv7-m": "cortex-m3",
    "@platforms//cpu:armv7e-m": "cortex-m4",
    "@platforms//cpu:armv7": "cortex-a8",
}

def cpu_constraint_value_as_qemu_cpu(value):
    """Convert a Bazel CPU constraint value to a QEMU CPU value.

    WARNING: This is not a perfect mapping, i.e. The armv6-m instruction set
    is used in Cortex-M[0|0+|1]. This is not captured in the mapping and is
    simulated as a Cortex-M0, regardless of the actual CPU. This is unlikely to
    be an issue in most cases. Likewise the armv7e-m instruction set is used in
    Cortex-M[4|7]. At the moment Cortex-m4 will be used by default.

    Args:
        value: A Bazel '@platforms//cpu:all' constraint value.

    Returns:
        A QEMU CPU value.
    """
    if not value.startswith("@platforms//cpu:"):
        fail("Invalid CPU constraint value: {}. This constraint should be from \
@platforms//cpu".format(value))
    return _BAZEL_TO_QEMU_CPU[value]

def _qemu_execution_wrapper_impl(ctx):
    wrapper = ctx.actions.declare_file(ctx.attr.name + ".sh")
    qemu = ctx.toolchains["//emulation/qemu:toolchain_type"].qemu_info.qemu
    script = ctx.toolchains["//emulation/qemu:toolchain_type"].qemu_info.script_template

    args = []
    if ctx.attr.semihosting_config:
        args.append("-semihosting-config " + ",".join([
            k + "=" + v
            for k, v in ctx.attr.semihosting_config.items()
        ]))
    if ctx.attr.machine != "":
        args.append("-machine " + ctx.attr.machine)
    if ctx.attr.cpu != "":
        args.append("-cpu" + ctx.attr.cpu)
    if ctx.attr.graphical != "":
        args.append("-nographic")
    if ctx.attr.reboot_on_exit != "":
        args.append("-no-reboot")

    if qemu != None:
        ctx.actions.expand_template(
            template = script,
            output = wrapper,
            substitutions = {
                "{WORKSPACE}": ctx.workspace_name,
                "{QEMU}": qemu.path,
                "{ARGS}": " ".join(args),
            },
            is_executable = True,
        )
    else:
        ctx.actions.symlink(
            output = wrapper,
            target_file = script,
        )

    return [DefaultInfo(
        files = depset([wrapper]),
        executable = wrapper,
        runfiles = ctx.runfiles(files = [qemu]) if qemu else None,
    )]

qemu_execution_wrapper = rule(
    _qemu_execution_wrapper_impl,
    attrs = {
        "_qemu": attr.string(default = "/usr/bin/qemu-system-arm"),
        "semihosting_config": attr.string_dict(
            default = {},
            doc =
                """A key value map of semihosting configuration options.

HINT: This maps directly to the QEMU sub options under `-semihosting-config`.
See man page for more information.
""",
        ),
        "cpu": attr.string(
            doc = "The CPU to use for this qemu instance. This is the QEMU CPU type, to simplify the mapping between @platforms//cpu:all->qemu_cpus see cpu_constraint_value_as_qemu_cpu.",
        ),
        "machine": attr.string(
            doc = "The machine type to use for the QEMU instance. Run `qemu-system-arm -machine help` to see the list of supported machines.",
        ),
        "kernel": attr.label(
            doc = "The kernel to use for this qemu instance. This must be an ELF file.",
        ),
        "graphical": attr.bool(
            doc = "Enable graphics or not.",
            default = False,
        ),
        "reboot_on_exit": attr.bool(
            doc = "Reboot the system when the QEMU instance exits.",
            default = False,
        ),
    },
    toolchains = ["//emulation/qemu:toolchain_type"],
    executable = True,
)
