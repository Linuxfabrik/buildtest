#!/usr/bin/env bash

set -e -x

SRC="$1"
DEST="$2"

mkdir -p "$DEST"

for file in "$SRC"/*; do
    echo "Merging files from $file into $DEST"
    \cp -r "$file"/* "$DEST"/
done
