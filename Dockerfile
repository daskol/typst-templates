FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="Daniel Bershatsky <https://github.com/daskol>"
LABEL org.opencontainers.image.description="Sandbox for template testing."
LABEL org.opencontainers.image.url=https://github.com/daskol/typst-templates
LABEL org.opencontainers.image.source=https://github.com/daskol/typst-templates
LABEL org.opencontainers.image.licenses=MIT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt update && \
    apt install -y --no-install-recommends \
        ca-certificates curl git xz-utils && \
    rm -rf /var/lib/apt/lists/*

RUN cat <<'EOF' >install-typst.sh && \
    bash install-typst.sh && \
    rm -rfv install-typst.sh
#/usr/bin/env bash

set -e

REPO=https://github.com/typst/typst
FILENAME=typst-x86_64-unknown-linux-musl.tar.xz

prefix=${1-/usr}
echo "use prefix ${prefix}"

declare -a vers=('0.12.0' '0.13.0' '0.13.1' '0.14.0' '0.14.1' '0.14.2')
for ver in "${vers[@]}"; do
    echo "install typst ${ver} to prefix ${prefix}"
    curl -LO "$REPO/releases/download/v$ver/$FILENAME"
    tar  xf "$FILENAME" --strip-components=1 \
        'typst-x86_64-unknown-linux-musl/LICENSE' \
        'typst-x86_64-unknown-linux-musl/typst'
    install -DT typst "$prefix/bin/typst-$ver"
    install -Dt "$prefix/share/licenses/typst-$ver" LICENSE
    rm -rfv "$FILENAME" LICENSE typst
done

if [ -n "${ver}" ]; then
    echo "link typst to latest version typst-v${ver}"
    ln -sf "typst-${ver}" "$prefix/bin/typst"
fi
EOF
