#!/usr/bin/env bash
# See https://gitlab.com/comprehensive-tex-archive-network/ctan-mirror for
# details (script `choose-mirror.pl`).

set -xeo pipefail

mirror=https://mirror.truenetwork.ru/CTAN/
index=FILES.byname.gz
output_dir="$(dirname $0)"
index_bst="${output_dir}/index.txt"
download_list="${output_dir}/download-list.txt"

echo "fetch full file index from $mirror$index"
curl -sL "$mirror$index" -o $index

echo "filter file index for bst-files"
total=$(zgrep -e '\.bst$' $index | awk '{ print $5 }' | tee $index_bst \
       |sort | uniq | wc -l)

echo "total $total bst files"

echo 'prepare download list'
(sed "s|.*|${mirror}&\n  out=corpus/&|" "${index_bst}" \
|tee "${download_list}" | wc -l)

echo 'fetch bst-files according download list'
aria2c -c -i "${download_list}"

echo 'prepare file list for compression'
find corpus -type f -iname '*.bst' | sort > corpus-index.txt
cp corpus-index.txt file-list.txt
echo 'corpus-index.txt' >> file-list.txt

echo 'prepare corpus tarball (xz)'
tar cfJT corpus.tar.xz file-list.txt

echo 'prepare corpus tarball (brotli)'
tar cfTI corpus.tar.br file-list.txt brotli
