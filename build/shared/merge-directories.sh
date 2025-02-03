#!/usr/bin/env bash

set -e -x

SRC="$1"
DEST="$2"

mkdir -p "$DEST"

cd "$SRC"
for dir in */*; do
    \cp --recursive --verbose "$dir"* "$DEST"/
done
