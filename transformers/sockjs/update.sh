#!/usr/bin/env bash

set -e

DESTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TEMPDIR=$(mktemp -d 2> /dev/null || mktemp -d -t 'tmp')

cleanup () {
  [ -d "$TEMPDIR" ] && rm -rf "$TEMPDIR"
}

trap cleanup INT TERM EXIT

git clone https://github.com/sockjs/sockjs-client.git "$TEMPDIR"
cd "$TEMPDIR"
git checkout "$(git describe --tags --abbrev=0)"
NODE_ENV=production npm install
"$DESTDIR"/update_tools/globalify.sh "$TEMPDIR"
cd "$DESTDIR"
find patches -name '*.patch' -exec patch -i {} \;
