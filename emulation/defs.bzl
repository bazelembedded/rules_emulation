""" A set of rules for emulating different architectures. """

load(
    "//emulation/internal:qemu.bzl",
    _cpu_constraint_value_as_qemu_cpu = "cpu_constraint_value_as_qemu_cpu",
    _qemu_execution_wrapper = "qemu_execution_wrapper",
)

qemu_execution_wrapper = _qemu_execution_wrapper

cpu_constraint_value_as_qemu_cpu = _cpu_constraint_value_as_qemu_cpu
