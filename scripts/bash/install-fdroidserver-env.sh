#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN="$( cd "${DIR}/../../bin" && pwd )"

# ----------------------------------------
# add required dependencies to environment
# ----------------------------------------
wget_home="${BIN}/install-fdroidserver-deps/wget/1.19.4"
perl_home="${BIN}/install-fdroidserver-deps/perl/5.10.1"
export PATH="${wget_home}:${perl_home}:${PATH}"
