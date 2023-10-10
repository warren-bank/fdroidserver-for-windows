#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ----------------------------------------
# add required dependencies to environment
# ----------------------------------------
source "${DIR}/install-fdroidserver-env.sh"

# ------------------
# create a workspace
# ------------------
workspace="$( cd "${DIR}/../.." && pwd )"
workspace="${workspace}/virtualenv"
[ -d "$workspace" ] && rm -rf "$workspace"
mkdir -p "$workspace"
cd "$workspace"

# -------------------------------------------------
# create a new virtual environment within workspace
# -------------------------------------------------
namespace='fdroid-server'
virtualenv "$namespace"

# --------------------------------
# activate the virtual environment
# --------------------------------
source "${namespace}/Scripts/activate"
export PYTHONPATH=$(cd "${namespace}/Lib/site-packages" && pwd)
export PYTHONWARNINGS='ignore'
export PYTHONIOENCODING='utf-8'
export PYTHONUTF8='1'

# --------------------------------------------------------------------
# install fdroidserver and all dependencies to the virtual environment
# --------------------------------------------------------------------
# see:
#   https://f-droid.org/docs/Installing_the_Server_and_Repo_Tools/#installing-the-latest-code-any-platform
# --------------------------------------------------------------------

# --------------------------------------------------------------------
# download tagged snapshot from fdroidserver git repo
# --------------------------------------------------------------------
# note:
#   tag '2.1.2' is the last version to support Python 3.5+
# see:
#   https://github.com/f-droid/fdroidserver/blob/2.1.2/setup.py#L97
# --------------------------------------------------------------------
git_repo='fork-fdroidserver'
git_ref='winpython_3.7.1.0'
wget -O "${git_repo}-${git_ref}.zip" "https://github.com/warren-bank/${git_repo}/archive/refs/heads/${git_ref}.zip"
unzip "${git_repo}-${git_ref}.zip"
mv "${git_repo}-${git_ref}/fdroidserver" "${namespace}/fdroidserver"
mv "${git_repo}-${git_ref}/fdroid"       "${namespace}/fdroid"
mv "${git_repo}-${git_ref}/mypy.ini"     "${namespace}/mypy.ini"
mv "${git_repo}-${git_ref}/setup.py"     "${namespace}/setup.py"
echo "${git_repo} v${git_ref}"         > "${namespace}/README.md"
rm -rf "${git_repo}-${git_ref}"
rm  -f "${git_repo}-${git_ref}.zip"

# --------------------------------------------
# remove unwanted setup dependencies and tasks
# --------------------------------------------
cp "${namespace}/setup.py" "${namespace}/setup.py.bak"

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*'versioncheck':\\s*VersionCheckCommand,\\s*$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*'install':\\s*InstallWithCompile,\\s*$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*data_files=get_data_files\\(\\),\\s*$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*scripts=\\['makebuildserver'\\],\\s*$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

# [install-issues.txt] #01
cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -pe "s/^(\\s*'requests >= 2\\.5\\.2)(?:, .+)?(',\\s*)$/\\1, < 2.30.0\\2/;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

rm -f "${namespace}/setup.py.tmp"

# ---------
# run setup
# ---------
pip install "./${namespace}"

# ----------------------------------
# deactivate the virtual environment
# ----------------------------------
deactivate
