#!/usr/bin/env bash

set -eou pipefail

HASH_DIR=${HASH_DIR:-docker}

find "${HASH_DIR}" -type f -exec md5sum {} \; \
    | sort \
    | md5sum \
    | cut -d' ' -f1
