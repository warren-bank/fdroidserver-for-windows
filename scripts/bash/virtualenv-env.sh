#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN="$( cd "${DIR}/../../bin" && pwd )"

# ----------------------------------------
# add required dependencies to environment
# ----------------------------------------
export ANDROID_HOME="${BIN}/virtualenv-deps/android-sdk"
export PATH="${ANDROID_HOME}/build-tools/30.0.1:${PATH}"

# --------------------------------------------------------------------
# external dependency
# --------------------------------------------------------------------
# see:
#   https://portableapps.com/apps/utilities/jdkportable
# --------------------------------------------------------------------
export JAVA_HOME='/c/PortableApps/Java_JDK/8u381'
export PATH="${JAVA_HOME}/bin:${PATH}"
