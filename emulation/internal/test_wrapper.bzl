""" A set of rules for repurposing the output of a genrule as a test """

def _test_wrapper_impl(ctx):
    executable = ctx.actions.declare_file(ctx.attr.name)
    ctx.actions.symlink(output = executable, target_file = ctx.file.target)
    return [DefaultInfo(files = depset([executable]), executable = executable)]

executable_test = rule(
    _test_wrapper_impl,
    test = True,
    attrs = {
        "target": attr.label(allow_single_file = True, mandatory = True),
    },
)
