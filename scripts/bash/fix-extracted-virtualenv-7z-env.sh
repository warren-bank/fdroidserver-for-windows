#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN="$( cd "${DIR}/../../bin" && pwd )"

# ----------------------------------------
# add required dependencies to environment
# ----------------------------------------
NIRCMD_HOME="${BIN}/fix-extracted-virtualenv-7z-deps/nircmd/2.86"
export PATH="${NIRCMD_HOME}:${PATH}"
