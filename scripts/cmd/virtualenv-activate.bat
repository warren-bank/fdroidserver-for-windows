@echo off

set DIR=%~dp0.

rem :: ----------------------------------------
rem :: add required dependencies to environment
rem :: ----------------------------------------
call "%DIR%\virtualenv-env.bat"

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

rem :: --------------------------------
rem :: activate the virtual environment
rem :: --------------------------------
call "%workspace%\%namespace%\Scripts\activate.bat"
set PYTHONPATH=%workspace%\%namespace%\Lib\site-packages
set PYTHONWARNINGS=ignore
set PYTHONIOENCODING=utf-8
set PYTHONUTF8=1
