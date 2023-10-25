@echo off

set DIR=%~dp0.

rem :: ----------------------------------------
rem :: add required dependencies to environment
rem :: ----------------------------------------
call "%DIR%\fix-extracted-virtualenv-7z-env.bat"

rem :: -------------
rem :: use workspace
rem :: -------------
set workspace=%DIR%\..\..
call "%DIR%\util\resolve_path.bat" "%workspace%"
set workspace=%resolved_path%\virtualenv
set namespace=fdroid-server

rem :: ------------
rem :: sanity check
rem :: ------------

if not exist "%workspace%\%namespace%" (
  echo virtualenv not found
  exit /b 1
)

if not defined WINPYDIR (
  echo WINPYDIR is not defined
  exit /b 2
)

if not exist "%WINPYDIR%" (
  echo WINPYDIR not found
  exit /b 3
)

rem :: --------------------
rem :: remove all shortcuts
rem :: --------------------
call :remove_shortcut "%workspace%\%namespace%\Scripts\_asyncio.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_bz2.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_contextvars.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_ctypes.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_decimal.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_distutils_findvs.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_elementtree.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_hashlib.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_lzma.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_msi.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_multiprocessing.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_overlapped.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_queue.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_socket.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_sqlite3.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_ssl.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\_tkinter.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\concrt140.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\libcrypto-1_1-x64.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\libssl-1_1-x64.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\msvcp140.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\pyexpat.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\python.exe"
call :remove_shortcut "%workspace%\%namespace%\Scripts\python3.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\python37.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\pythonw.exe"
call :remove_shortcut "%workspace%\%namespace%\Scripts\select.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\sqlite3.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\tcl86t.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\tk86t.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\unicodedata.pyd"
call :remove_shortcut "%workspace%\%namespace%\Scripts\vccorlib140.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\vcomp140.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\vcruntime140.dll"
call :remove_shortcut "%workspace%\%namespace%\Scripts\winsound.pyd"

rem :: ---------------------------------------------------------------
rem :: recreate all shortcuts
rem :: ---------------------------------------------------------------
rem :: references:
rem ::   https://www.nirsoft.net/utils/nircmd.html
rem ::   https://www.nirsoft.net/utils/nircmd2.html#shortcut
rem :: ---------------------------------------------------------------
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_asyncio.pyd"          "%workspace%\%namespace%\Scripts" "_asyncio.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_bz2.pyd"              "%workspace%\%namespace%\Scripts" "_bz2.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_contextvars.pyd"      "%workspace%\%namespace%\Scripts" "_contextvars.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_ctypes.pyd"           "%workspace%\%namespace%\Scripts" "_ctypes.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_decimal.pyd"          "%workspace%\%namespace%\Scripts" "_decimal.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_distutils_findvs.pyd" "%workspace%\%namespace%\Scripts" "_distutils_findvs.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_elementtree.pyd"      "%workspace%\%namespace%\Scripts" "_elementtree.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_hashlib.pyd"          "%workspace%\%namespace%\Scripts" "_hashlib.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_lzma.pyd"             "%workspace%\%namespace%\Scripts" "_lzma.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_msi.pyd"              "%workspace%\%namespace%\Scripts" "_msi.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_multiprocessing.pyd"  "%workspace%\%namespace%\Scripts" "_multiprocessing.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_overlapped.pyd"       "%workspace%\%namespace%\Scripts" "_overlapped.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_queue.pyd"            "%workspace%\%namespace%\Scripts" "_queue.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_socket.pyd"           "%workspace%\%namespace%\Scripts" "_socket.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_sqlite3.pyd"          "%workspace%\%namespace%\Scripts" "_sqlite3.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_ssl.pyd"              "%workspace%\%namespace%\Scripts" "_ssl.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\_tkinter.pyd"          "%workspace%\%namespace%\Scripts" "_tkinter.pyd"
nircmdc.exe shortcut "%WINPYDIR%\concrt140.dll"              "%workspace%\%namespace%\Scripts" "concrt140.dll"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\libcrypto-1_1-x64.dll" "%workspace%\%namespace%\Scripts" "libcrypto-1_1-x64.dll"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\libssl-1_1-x64.dll"    "%workspace%\%namespace%\Scripts" "libssl-1_1-x64.dll"
nircmdc.exe shortcut "%WINPYDIR%\msvcp140.dll"               "%workspace%\%namespace%\Scripts" "msvcp140.dll"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\pyexpat.pyd"           "%workspace%\%namespace%\Scripts" "pyexpat.pyd"
nircmdc.exe shortcut "%WINPYDIR%\python.exe"                 "%workspace%\%namespace%\Scripts" "python.exe"
nircmdc.exe shortcut "%WINPYDIR%\python3.dll"                "%workspace%\%namespace%\Scripts" "python3.dll"
nircmdc.exe shortcut "%WINPYDIR%\python37.dll"               "%workspace%\%namespace%\Scripts" "python37.dll"
nircmdc.exe shortcut "%WINPYDIR%\pythonw.exe"                "%workspace%\%namespace%\Scripts" "pythonw.exe"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\select.pyd"            "%workspace%\%namespace%\Scripts" "select.pyd"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\sqlite3.dll"           "%workspace%\%namespace%\Scripts" "sqlite3.dll"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\tcl86t.dll"            "%workspace%\%namespace%\Scripts" "tcl86t.dll"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\tk86t.dll"             "%workspace%\%namespace%\Scripts" "tk86t.dll"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\unicodedata.pyd"       "%workspace%\%namespace%\Scripts" "unicodedata.pyd"
nircmdc.exe shortcut "%WINPYDIR%\vccorlib140.dll"            "%workspace%\%namespace%\Scripts" "vccorlib140.dll"
nircmdc.exe shortcut "%WINPYDIR%\vcomp140.dll"               "%workspace%\%namespace%\Scripts" "vcomp140.dll"
nircmdc.exe shortcut "%WINPYDIR%\vcruntime140.dll"           "%workspace%\%namespace%\Scripts" "vcruntime140.dll"
nircmdc.exe shortcut "%WINPYDIR%\DLLs\winsound.pyd"          "%workspace%\%namespace%\Scripts" "winsound.pyd"

goto :done

:remove_shortcut
  set shortcut_filepath=%~1
  if exist "%shortcut_filepath%"     del "%shortcut_filepath%"
  if exist "%shortcut_filepath%.lnk" del "%shortcut_filepath%.lnk"
  goto :eof

:done
