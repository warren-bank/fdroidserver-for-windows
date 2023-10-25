#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ----------------------------------------
# add required dependencies to environment
# ----------------------------------------
source "${DIR}/fix-extracted-virtualenv-7z-env.sh"

# -------------
# use workspace
# -------------
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

if [ "$WINPYDIR" == '' ];then
  echo 'WINPYDIR is not defined'
  exit 2
fi

if [ ! -d "$WINPYDIR" ];then
  echo 'WINPYDIR not found'
  exit 3
fi

# --------------------
# remove all shortcuts
# --------------------

function remove_shortcut() {
  shortcut_filepath="$1"
  [ -e "$shortcut_filepath" ]       && rm -f "$shortcut_filepath"
  [ -e "${shortcut_filepath}.lnk" ] && rm -f "${shortcut_filepath}.lnk"
}

remove_shortcut "${workspace}/${namespace}/Scripts/_asyncio.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_bz2.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_contextvars.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_ctypes.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_decimal.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_distutils_findvs.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_elementtree.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_hashlib.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_lzma.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_msi.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_multiprocessing.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_overlapped.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_queue.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_socket.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_sqlite3.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_ssl.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/_tkinter.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/concrt140.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/libcrypto-1_1-x64.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/libssl-1_1-x64.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/msvcp140.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/pyexpat.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/python.exe"
remove_shortcut "${workspace}/${namespace}/Scripts/python3.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/python37.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/pythonw.exe"
remove_shortcut "${workspace}/${namespace}/Scripts/select.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/sqlite3.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/tcl86t.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/tk86t.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/unicodedata.pyd"
remove_shortcut "${workspace}/${namespace}/Scripts/vccorlib140.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/vcomp140.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/vcruntime140.dll"
remove_shortcut "${workspace}/${namespace}/Scripts/winsound.pyd"

# --------------------------------------------------------------------
# recreate all shortcuts
# --------------------------------------------------------------------
# references:
#   https://www.nirsoft.net/utils/nircmd.html
#   https://www.nirsoft.net/utils/nircmd2.html#shortcut
# --------------------------------------------------------------------
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_asyncio.pyd"          "${workspace}/${namespace}/Scripts" "_asyncio.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_bz2.pyd"              "${workspace}/${namespace}/Scripts" "_bz2.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_contextvars.pyd"      "${workspace}/${namespace}/Scripts" "_contextvars.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_ctypes.pyd"           "${workspace}/${namespace}/Scripts" "_ctypes.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_decimal.pyd"          "${workspace}/${namespace}/Scripts" "_decimal.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_distutils_findvs.pyd" "${workspace}/${namespace}/Scripts" "_distutils_findvs.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_elementtree.pyd"      "${workspace}/${namespace}/Scripts" "_elementtree.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_hashlib.pyd"          "${workspace}/${namespace}/Scripts" "_hashlib.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_lzma.pyd"             "${workspace}/${namespace}/Scripts" "_lzma.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_msi.pyd"              "${workspace}/${namespace}/Scripts" "_msi.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_multiprocessing.pyd"  "${workspace}/${namespace}/Scripts" "_multiprocessing.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_overlapped.pyd"       "${workspace}/${namespace}/Scripts" "_overlapped.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_queue.pyd"            "${workspace}/${namespace}/Scripts" "_queue.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_socket.pyd"           "${workspace}/${namespace}/Scripts" "_socket.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_sqlite3.pyd"          "${workspace}/${namespace}/Scripts" "_sqlite3.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_ssl.pyd"              "${workspace}/${namespace}/Scripts" "_ssl.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/_tkinter.pyd"          "${workspace}/${namespace}/Scripts" "_tkinter.pyd"
nircmdc.exe shortcut "${WINPYDIR}/concrt140.dll"              "${workspace}/${namespace}/Scripts" "concrt140.dll"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/libcrypto-1_1-x64.dll" "${workspace}/${namespace}/Scripts" "libcrypto-1_1-x64.dll"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/libssl-1_1-x64.dll"    "${workspace}/${namespace}/Scripts" "libssl-1_1-x64.dll"
nircmdc.exe shortcut "${WINPYDIR}/msvcp140.dll"               "${workspace}/${namespace}/Scripts" "msvcp140.dll"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/pyexpat.pyd"           "${workspace}/${namespace}/Scripts" "pyexpat.pyd"
nircmdc.exe shortcut "${WINPYDIR}/python.exe"                 "${workspace}/${namespace}/Scripts" "python.exe"
nircmdc.exe shortcut "${WINPYDIR}/python3.dll"                "${workspace}/${namespace}/Scripts" "python3.dll"
nircmdc.exe shortcut "${WINPYDIR}/python37.dll"               "${workspace}/${namespace}/Scripts" "python37.dll"
nircmdc.exe shortcut "${WINPYDIR}/pythonw.exe"                "${workspace}/${namespace}/Scripts" "pythonw.exe"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/select.pyd"            "${workspace}/${namespace}/Scripts" "select.pyd"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/sqlite3.dll"           "${workspace}/${namespace}/Scripts" "sqlite3.dll"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/tcl86t.dll"            "${workspace}/${namespace}/Scripts" "tcl86t.dll"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/tk86t.dll"             "${workspace}/${namespace}/Scripts" "tk86t.dll"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/unicodedata.pyd"       "${workspace}/${namespace}/Scripts" "unicodedata.pyd"
nircmdc.exe shortcut "${WINPYDIR}/vccorlib140.dll"            "${workspace}/${namespace}/Scripts" "vccorlib140.dll"
nircmdc.exe shortcut "${WINPYDIR}/vcomp140.dll"               "${workspace}/${namespace}/Scripts" "vcomp140.dll"
nircmdc.exe shortcut "${WINPYDIR}/vcruntime140.dll"           "${workspace}/${namespace}/Scripts" "vcruntime140.dll"
nircmdc.exe shortcut "${WINPYDIR}/DLLs/winsound.pyd"          "${workspace}/${namespace}/Scripts" "winsound.pyd"
