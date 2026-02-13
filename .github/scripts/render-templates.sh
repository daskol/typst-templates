#!/usr/bin/env bash
# A simple script to check that a template can be rendered with a specific
# version of `typst` compiler.
#
#   PREFIX=build .github/scripts/render-templates.sh 0.14.0

function render-template() {
    local typstc=${1-typst}
    local root=${2-.}
    ${typstc} compile "${root}/main.typ" \
        --diagnostic-format=short \
        --format=pdf \
        --root="${root}"
}

typstc="typst"
if [ -n "${PREFIX}" ]; then
    typstc="${PREFIX}/bin/$typstc"
fi

typst_version=${1}
if [ -n "${typst_version}" ]; then
    typstc="${typstc}-${typst_version}"
fi

if ! command -pv "${typstc}" >/dev/null; then
    echo "no typst v${typst_version} (${typstc}) compiler found"
    exit 1
else
    command "$typstc" -V
fi

roots=$(find -type f -iname 'typst.toml' -printf '%h\n')
if [ -z "${roots}" ]; then
    echo 'no typst templates found: no `typst.toml` files'
    exit 0
fi

rc=0  # Accumulate failures.
while IFS= read -r root; do
    echo "try to render template located at ${root}"
    render-template "$typstc" "$root" || rc=1
done <<< "${roots}"

exit "$rc"
