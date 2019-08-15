"""Providers for interop between JS rules.

This file has to live in the built-in so that all rules can load() the providers
even if users haven't installed any of the packages/*

These providers allows rules to interoperate without knowledge
of each other.

You can think of a provider as a message bus.
A rule "publishes" a message as an instance of the provider, and some other rule
subscribes to these by having a (possibly transitive) dependency on the publisher.

## Sourcemaps

Sourcemap files should always accompany JS files that have been transformed from
the user's authored files.
Sourcemaps may be inline in the JS files. For the `named` provider, we assume
this is the case, as it makes it much easier to serve the sourcemaps in devmode.
They may also be in separate files ending with `.map`.

## Debugging

Debug output is considered orthogonal to these providers.
Any output may or may not have user debugging affordances provided, such as
readable minification.
We expect that rules will have a boolean `debug` attribute, and/or accept the `DEBUG`
environment variable.
Note that this means a given build either produces debug or non-debug output.
If users really need to produce both in a single build, they'll need two rules with
differing 'debug' attributes.
"""

JSBundleInfo = provider(
    fields = {
        "module_format": "a string like cjs, umd",
    },
)

JSInfo = provider(
    doc = """Individual JS files. They may be produced by a rule like a transpile-to-JS compiler.
""",
    fields = {
        # TODO: bike-shed the name
        "esnext": """JavaScript files (and sourcemaps) that are intended to be consumed by downstream tooling.

They should use modern syntax and ESModules.
These files should typically be named "foo.mjs"
TODO: should we require that?

Historical note: this was the typescript.es6_sources output""",

        # TODO: bike-shed the name
        "named": """JavaScript files whose module name is self-contained.

For example named AMD/UMD or goog.module format.
These files can be efficiently served with the concatjs bundler.
These outputs should be named "foo.umd.js"
(note that renaming it from "foo.js" doesn't affect the module id)

Historical note: this was the typescript.es5_sources output""",

        # TODO: do we need something like a third flavor?
        # Or could this just be the DefaultInfo of tools that want to produce three flavors?
        #"user": """JavaScript files whose format is user-controlled.
        #        Consumers cannot make any assumptions about how to correctly handle it.""",
    },
)

TypingsInfo = provider(
    doc = """The TypingsInfo provider allows JS rules to communicate typing information.

TypeScript's .d.ts files are used as the interop format for describing types.

The ts_library#deps attribute should require that this provider is attached.

Note: historically this was in the string-typed "typescript" provider.
""",
    fields = {
        "declarations": "A depset of .d.ts files produced by this rule",
        "transitive_declarations": """A depset of .d.ts files produced by this rule and all its transitive dependencies.
This prevents needing an aspect in rules that consume the typings, which improves performance.""",
    },
)

# TsickleInfo might be a needed provider to send tsickle_externs and type_blacklisted_declarations
