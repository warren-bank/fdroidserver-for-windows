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
# versions of globally installed packages:
#   pip 23.3
#   virtualenv 20.0.31
# -------------------------------------------------
# installation of these packages:
#   python -m pip install --upgrade pip=23.3
#   pip install virtualenv==20.0.31
# -------------------------------------------------
namespace='fdroid-server'
virtualenv "$namespace" --pip "$(python.exe -c 'import pip; print(pip.__version__)')"

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
wget --no-check-certificate --no-show-progress -O "${git_repo}-${git_ref}.zip" "https://github.com/warren-bank/${git_repo}/archive/refs/heads/${git_ref}.zip"
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
if [ "$backup_modified_files" == '1' ];then
  cp "${namespace}/setup.py" "${namespace}/setup.py.bak"
fi

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*'versioncheck':\\s*VersionCheckCommand,\\s*\$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*'install':\\s*InstallWithCompile,\\s*\$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*data_files=get_data_files\\(\\),\\s*\$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -ne "/^\\s*scripts=\\['makebuildserver'\\],\\s*\$/ || print \$_;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

# [install-issues.txt] #01
cp "${namespace}/setup.py" "${namespace}/setup.py.tmp"
perl -pe "s/^(\\s*'requests >= 2\\.5\\.2)(?:, .+)?(',\\s*)\$/\\1, < 2.30.0\\2/;" "${namespace}/setup.py.tmp" > "${namespace}/setup.py"

rm -f "${namespace}/setup.py.tmp"

# --------------------------------
# activate the virtual environment
# --------------------------------
source "${namespace}/Scripts/activate"
export PYTHONPATH=$(cd "${namespace}/Lib/site-packages" && pwd)
export PYTHONWARNINGS='ignore'
export PYTHONIOENCODING='utf-8'
export PYTHONUTF8='1'

# ---------
# run setup
# ---------
# the "right" way:
#   pip install "./${namespace}"
# ---------
# the "hacky" way..
# to override the shebang included in both:
# Python scripts, and Python scripts embedded into Windows executables.
# ---------
# see:
#   https://github.com/pypa/pip/issues/4616
#   https://pip.pypa.io/en/stable/cli/pip/
# ---------
python.exe -c "import pip, sys; sys.executable='python.exe'; pip.main()" --require-virtualenv --no-cache-dir --python "${workspace}/${namespace}/Scripts/python.exe" --quiet --disable-pip-version-check install "./${namespace}"

# ----------------------------------
# deactivate the virtual environment
# ----------------------------------
deactivate

# -------------------------------------------------------
# start:
#   replace absolute paths in virtual environment scripts
# -------------------------------------------------------

# -----------------------------------------------------
# 1) update bash script
#      file: activate
#      line: 49
#      code: VIRTUAL_ENV='E:\fd\virtualenv\fdroid-server'
#      fix:  VIRTUAL_ENV="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# -----------------------------------------------------

cp "${namespace}/Scripts/activate" "${namespace}/Scripts/activate.sh.bak"
perl -pe "s/^(VIRTUAL_ENV=).+\$/\\1\"\\\$( cd \"\\\$( dirname \"\\\${BASH_SOURCE[0]}\" )\/..\" && pwd )\"/;" "${namespace}/Scripts/activate.sh.bak" > "${namespace}/Scripts/activate"
[ "$backup_modified_files" == '1' ] || rm -f "${namespace}/Scripts/activate.sh.bak"

# -----------------------------------------------------
# 2) update cmd script
#      file: activate.bat
#      line: 5
#      code: set "VIRTUAL_ENV=E:\fd\virtualenv\fdroid-server"
#      fix:  set "VIRTUAL_ENV=%~dp0.."
# -----------------------------------------------------

cp "${namespace}/Scripts/activate.bat" "${namespace}/Scripts/activate.bat.bak"
perl -pe "s/^(set \"VIRTUAL_ENV=).+\$/\\1%~dp0..\"/;" "${namespace}/Scripts/activate.bat.bak" > "${namespace}/Scripts/activate.bat"
[ "$backup_modified_files" == '1' ] || rm -f "${namespace}/Scripts/activate.bat.bak"

# -------------------------------------------------------
# end:
#   replace absolute paths in virtual environment scripts
# -------------------------------------------------------
