#!/usr/bin/env bash

set -e -x

SRC="$1"
DEST="$2"

cp -a $SRC/*.dist/. $DEST/
