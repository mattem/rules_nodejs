"Rule implementations to run rollup under Bazel"

load("@build_bazel_rules_nodejs//:providers.bzl", "JSModuleInfo")

ROLLUP_BUNDLE_ATTRS = {
    "srcs": attr.label_list(
        doc = "TODO: copy over",
        allow_files = [".js"],
    ),
    "config_file": attr.label(
        doc = "TODO",
        allow_single_file = True,
    ),
    "entry_point": attr.label(
        doc = "TODO: copy over",
        mandatory = True,
        allow_single_file = True,
    ),
    "format": attr.string(
        doc = "Rollup --format argument: [amd, cjs, esm, iife, umd]",
        default = "esm",
    ),
    "rollup_bin": attr.label(
        doc = "TODO",
        executable = True,
        cfg = "host",
        default = "@npm//@bazel/rollup/bin:rollup",
    ),
    "deps": attr.label_list(),
}

ROLLUP_BUNDLE_OUTS = {
    "bundle": "%{name}.js",
}

def _path_without_extension(f):
    return f.short_path[:-(len(f.extension) + 1)]

def run_rollup(ctx, sources, config, output):
    "TODO: doc - we want this function to be similar to existing one since ng_Package uses it"
    args = ctx.actions.args()
    args.add_all(["--input", _path_without_extension(ctx.file.entry_point)])
    args.add_all(["--format", ctx.attr.format])
    args.add_all(["--config", config.path])
    args.add_all(["--output.file", output.path])
    direct_inputs = [config, ctx.file.entry_point] + ctx.files.deps
    outputs = [output]
    ctx.actions.run(
        progress_message = "Bundling JavaScript %s [rollup]" % output.short_path,
        executable = ctx.executable.rollup_bin,
        inputs = depset(direct_inputs, transitive = [sources]),
        outputs = outputs,
        arguments = [args],
    )

def _rollup_bundle_impl(ctx):
    run_rollup(ctx, depset(ctx.files.srcs), ctx.file.config_file, ctx.outputs.bundle)

    return [
        DefaultInfo(files = depset([ctx.outputs.bundle])),
        JSModuleInfo(module_format = ctx.attr.format, sources = depset([ctx.outputs.bundle])),
    ]

rollup_bundle = rule(
    implementation = _rollup_bundle_impl,
    attrs = ROLLUP_BUNDLE_ATTRS,
    outputs = ROLLUP_BUNDLE_OUTS,
)
