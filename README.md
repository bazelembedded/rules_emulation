# rules_emulation
[![CI](https://github.com/bazelembedded/rules_emulation/actions/workflows/blank.yml/badge.svg)](https://github.com/bazelembedded/rules_emulation/actions/workflows/blank.yml)

A set of Bazel rules for emulating system targets for testing via an execution
wrapper.

To get started with this set of tools, go ahead and download the rules by adding
the following to your WORKSPACE.

```python
# WORKSPACE
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "rule_emulation",
    remote = "https://github.com/bazelembedded/rules_emulation.git",
    commit = "<TODO>",
)

load("@rules_emulation//:emulation_deps.bzl", "emulation_deps")

emulation_deps()

load("@rules_emulation//:emulation_workspace.bzl", "emulation_workspace")

emulation_workspace()

register_toolchains("@rules_emulation//emulation/qemu:all")
```

Add the following to a build file somewhere;
```python
# //some:BUILD.bazel
load("@rules_emulation//emulation:defs.bzl",
    "qemu_execution_wrapper",
    "cpu_constraint_value_as_qemu_cpu",
)

# Vanilla execution wrapper.
qemu_execution_wrapper(
    name = "lm3s6965evb_execution_wrapper",
    cpu = "cortex-m3",
    machine = "lm3s6965evb",
    target_compatible_with = ["@platforms//cpu:armv7-m"],
)

# Optionally use the Bazel constraint_value helper utility. e.g.
qemu_execution_wrapper(
    name = "lm3s6965evb_execution_wrapper_with_helper",
    machine = "lm3s6965evb",
    # Warning: this is experimental and may lead to unexpected results.
    cpu = cpu_constraint_value_as_qemu_cpu("@platforms//cpu:armv7-m"),
    target_compatible_with = ["@platforms//cpu:armv7-m"],
)

qemu_execution_wrapper(
    name = "cubieboard_execution_wrapper",
    machine = "cubieboard",
    # Warning: this is experimental and may lead to unexpected results.
    cpu = cpu_constraint_value_as_qemu_cpu("@platforms//cpu:armv7"),
    target_compatible_with = ["@platforms//cpu:armv7"],
)

alias(
    name = "execution_wrapper",
    # Create your own execution wrapper with any arbitrary select logic. e.g.
    actual = select({
        "@platforms//armv7-m": ":lm3s6965evb_execution_wrapper",
        "@platforms//armv7": ":cubieboard_execution_wrapper",
        # By default just passthrough and execute on exec target. This is
        # functionally a noop saying just pass through the arguments and
        # execute without qemu. This is useful so that you can permanently point
        # the --run_under flag at this target and it will still work for host
        # execution.
        "//conditions:default": "@rules_emulation//emulation:passthrough",
    }),
)
```

To make use of these execution wrappers you can use the `--run_under` flag e.g.
```sh
bazel test //:lm3s6965evb_only_test --run_under=//:lm3s6965evb_execution_wrapper
```

To simplify day to day development it can be useful to add the following to your
`.bazelrc`.
```
# Note that this is the alias targe which selects the target based on the
# platform.
test --run_under=//:execution_wrapper
```

For more information on selects/platforms see the
[Configurable Build Attributes](https://docs.bazel.build/versions/main/configurable-attributes.html)
page.