#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ----------------------------------------
# add required dependencies to environment
# ----------------------------------------
source "${DIR}/virtualenv-env.sh"

# ------------------
# create a workspace
# ------------------
workspace="$( cd "${DIR}/../.." && pwd )"
workspace="${workspace}/virtualenv"
namespace='fdroid-server'

# ------------
# sanity check
# ------------

if [ ! -d "${workspace}/${namespace}" ];then
  echo 'virtualenv not found'
  exit 1
fi

# --------------------------------
# activate the virtual environment
# --------------------------------
source "${workspace}/${namespace}/Scripts/activate"
export PYTHONPATH=$(cd "${workspace}/${namespace}/Lib/site-packages" && pwd)
export PYTHONWARNINGS='ignore'
export PYTHONIOENCODING='utf-8'
