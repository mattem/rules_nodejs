"""
Repository rule for downloading a version of esbuild for the current platform
"""

_PLATFORM_SHA = {
    "darwin_64": "3bf980b5175df873dd84fd614d57722f3b1b9c7e74929504e26192d23075d5c3",
    "linux_64": "9dff3f5b06fd964a1cbb6aa9ea5ebf797767f1bd2bac71e084fb0bbefeba24a3",
    "windows_64": "826cd58553e7b6910dd22aba001cd72af34e05c9c3e9af567b5b2a6b1c9f3941",
}

_VERSION = "0.8.34"

def _esbuild_repository_impl(rctx):
    platform_sha = rctx.attr.platform_sha
    version = rctx.attr.version

    URLS = {
        "linux": {
            "sha": platform_sha["linux_64"],
            "url": "https://registry.npmjs.org/esbuild-linux-64/-/esbuild-linux-64-%s.tgz" % version,
        },
        "mac os": {
            "sha": platform_sha["darwin_64"],
            "url": "https://registry.npmjs.org/esbuild-darwin-64/-/esbuild-darwin-64-%s.tgz" % version,
        },
        "windows": {
            "sha": platform_sha["windows_64"],
            "url": "https://registry.npmjs.org/esbuild-windows-64/-/esbuild-windows-64-%s.tgz" % version,
        },
    }

    os_name = rctx.os.name.lower()
    if os_name.startswith("mac os"):
        value = URLS["mac os"]
    elif os_name.find("windows") != -1:
        value = URLS["windows"]
    elif os_name.startswith("linux"):
        value = URLS["linux"]
    else:
        fail("Unsupported operating system: " + os_name)

    rctx.download_and_extract(
        value["url"],
        sha256 = value["sha"],
        stripPrefix = "package",
    )

    if os_name.startswith("windows"):
        rctx.delete("bin/esbuild")
        rctx.symlink("esbuild.exe", "bin/esbuild")

    rctx.file("BUILD", content = """exports_files(["bin/esbuild"])""")

_esbuild_repository = repository_rule(
    implementation = _esbuild_repository_impl,
    attrs = {
        "platform_sha": attr.string_dict(
            default = _PLATFORM_SHA,
            doc = """A dict mapping the platform to the SHA256 sum for that platforms esbuild package
The following platforms and archs are supported:
* darwin_64
* linux_64
* windows_64
            """,
        ),
        "version": attr.string(
            default = _VERSION,
            doc = "The version of esbuild to use",
        ),
    },
)

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)

def esbuild_dependencies(name = "esbuild", **kwargs):
    """Helper to install required dependencies for the esbuild rules

    Args:
        name: name for the repository, defaults to `esbuild`
        **kwargs: all other arguments from `esbuild_repository`
    """

    # TODO(mattem): add bazel_skylib here for the user, but due to https://github.com/bazelbuild/bazel/issues/12444 we can't reference `http_archive` yet
    # and have the docs generate

    _esbuild_repository(
        name = name,
        **kwargs
    )
