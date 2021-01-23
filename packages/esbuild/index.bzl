# Copyright 2020 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Public API surface is re-exported here.
"""

load(
    "@build_bazel_rules_nodejs//packages/esbuild:esbuild.bzl",
    _esbuild = "esbuild",
    _esbuild_bundle = "esbuild_bundle",
)
load(
    "@build_bazel_rules_nodejs//packages/esbuild:esbuild_repo.bzl",
    _esbuild_dependencies = "esbuild_dependencies",
)

esbuild = _esbuild
esbuild_bundle = _esbuild_bundle
esbuild_dependencies = _esbuild_dependencies

# DO NOT ADD MORE rules here unless they appear in the generated docsite.
# Run yarn stardoc to re-generate the docsite.
