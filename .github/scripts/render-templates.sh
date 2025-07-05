#!/usr/bin/env bash

set -x

function compile-template() {
    local typstc=${1-typst}
    local root=${2-.}
    typst -V
    typst compile "${root}/main.typ" \
        --diagnostic-format=short \
        --format=pdf \
        --root="${root}"
}

typstc=typst
typst_version=${1}
if [ -n "${typst_version}" ]; then
    typstc="typst-${typst_version}"
fi

if ! command -pv "${typstc}" >/dev/null; then
    echo "no typst v${typst_version} (${typstc}) compiler found"
    exit 1
fi

roots=$(find -type f -iname 'typst.toml' -printf '%h\n')
if [ -z "${roots}" ]; then
    echo 'no typst templates found: no `typst.toml` files'
    exit 0
fi

for root in "${roots}"; do
    compile-template "$typstc" "$root"
done
