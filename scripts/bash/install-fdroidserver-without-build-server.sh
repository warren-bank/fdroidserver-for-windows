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

# ---------
# run setup
# ---------
pip install "./${namespace}"

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

# -----------------------------------------------------
# 3) replace shebang in several Python scripts
#      line: 1
#      code: #!E:\fd\virtualenv\fdroid-server\Scripts\python.exe
#      fix1: #!python.exe
#      fix2: #!/usr/bin/env bash
#            "exec" "`dirname \"$0\"`/python" "$0" "$@"
#      docs:
#        https://stackoverflow.com/a/33225909
# -----------------------------------------------------

function replace_python_shebang() {
  replace_python_shebang_fix1 "$1"
}

function replace_python_shebang_fix1() {
  python_script_filepath="$1"

  cp "$python_script_filepath" "${python_script_filepath}.py.bak"
  perl -ne "if (\$. == 1) {print qq(#!python.exe\\n);} else {print \$_;}" "${python_script_filepath}.py.bak" > "$python_script_filepath"
  [ "$backup_modified_files" == '1' ] || rm -f "${python_script_filepath}.py.bak"
}

function replace_python_shebang_fix2() {
  python_script_filepath="$1"

  new_line_1='#!/usr/bin/env bash'
  new_line_2='"exec" "`dirname \\"\$0\\"`/python" "\$0" "\$@"'
  new_shebang="${new_line_1}\\n${new_line_2}\\n"

  cp "$python_script_filepath" "${python_script_filepath}.py.bak"
  perl -ne "if (\$. == 1) {print qq(${new_shebang});} else {print \$_;}" "${python_script_filepath}.py.bak" > "$python_script_filepath"
  [ "$backup_modified_files" == '1' ] || rm -f "${python_script_filepath}.py.bak"
}

replace_python_shebang "${namespace}/Scripts/prichunkpng"
replace_python_shebang "${namespace}/Scripts/pricolpng"
replace_python_shebang "${namespace}/Scripts/priditherpng"
replace_python_shebang "${namespace}/Scripts/priforgepng"
replace_python_shebang "${namespace}/Scripts/prigreypng"
replace_python_shebang "${namespace}/Scripts/pripalpng"
replace_python_shebang "${namespace}/Scripts/pripamtopng"
replace_python_shebang "${namespace}/Scripts/priplan9topng"
replace_python_shebang "${namespace}/Scripts/pripnglsch"
replace_python_shebang "${namespace}/Scripts/pripngtopam"
replace_python_shebang "${namespace}/Scripts/prirowpng"
replace_python_shebang "${namespace}/Scripts/priweavepng"

# -----------------------------------------------------
# 4) replace shebang in several Windows executables
#      line: 1x line that can occur anywhere in file
#      code: #!E:\fd\virtualenv\fdroid-server\Scripts\python.exe
#      fix : #!python.exe
#            #\fd\virtualenv\fdroid-server\Scripts\
#      note: the total string length must not change.
#            "E:" is replaced by: "\n#"
# -----------------------------------------------------

function replace_win_shebang() {
  win_exe_filepath="$1"

  cp "$win_exe_filepath" "${win_exe_filepath}.bak"
  perl -e 'open (IN, q(<), qq($ARGV[0])) or die $!; open (OUT, q(>), qq($ARGV[1])) or die $!; binmode IN; binmode OUT; my $buf = do {local $/; <IN> }; $buf =~ s/(\#\!)[A-Za-z]:(\\(?:[^\\]+\\)*)(python\.exe)/\1\3\n#\2/; print OUT $buf;' "${win_exe_filepath}.bak" "$win_exe_filepath"
  [ "$backup_modified_files" == '1' ] || rm -f "${win_exe_filepath}.bak"
}

replace_win_shebang "${namespace}/Scripts/androapkid.exe"
replace_win_shebang "${namespace}/Scripts/androarsc.exe"
replace_win_shebang "${namespace}/Scripts/androaxml.exe"
replace_win_shebang "${namespace}/Scripts/androcg.exe"
replace_win_shebang "${namespace}/Scripts/androdd.exe"
replace_win_shebang "${namespace}/Scripts/androdis.exe"
replace_win_shebang "${namespace}/Scripts/androguard.exe"
replace_win_shebang "${namespace}/Scripts/androgui.exe"
replace_win_shebang "${namespace}/Scripts/androlyze.exe"
replace_win_shebang "${namespace}/Scripts/androsign.exe"
replace_win_shebang "${namespace}/Scripts/f2py.exe"
replace_win_shebang "${namespace}/Scripts/fdroid.exe"
replace_win_shebang "${namespace}/Scripts/fonttools.exe"
replace_win_shebang "${namespace}/Scripts/iptest.exe"
replace_win_shebang "${namespace}/Scripts/iptest3.exe"
replace_win_shebang "${namespace}/Scripts/ipython.exe"
replace_win_shebang "${namespace}/Scripts/ipython3.exe"
replace_win_shebang "${namespace}/Scripts/normalizer.exe"
replace_win_shebang "${namespace}/Scripts/pip-3.7.exe"
replace_win_shebang "${namespace}/Scripts/pip.exe"
replace_win_shebang "${namespace}/Scripts/pip3.7.exe"
replace_win_shebang "${namespace}/Scripts/pip3.exe"
replace_win_shebang "${namespace}/Scripts/pyftmerge.exe"
replace_win_shebang "${namespace}/Scripts/pyftsubset.exe"
replace_win_shebang "${namespace}/Scripts/pygmentize.exe"
replace_win_shebang "${namespace}/Scripts/qr.exe"
replace_win_shebang "${namespace}/Scripts/ttx.exe"
replace_win_shebang "${namespace}/Scripts/wheel-3.7.exe"
replace_win_shebang "${namespace}/Scripts/wheel.exe"
replace_win_shebang "${namespace}/Scripts/wheel3.7.exe"
replace_win_shebang "${namespace}/Scripts/wheel3.exe"
replace_win_shebang "${namespace}/Scripts/yamllint.exe"

# -------------------------------------------------------
# end:
#   replace absolute paths in virtual environment scripts
# -------------------------------------------------------
