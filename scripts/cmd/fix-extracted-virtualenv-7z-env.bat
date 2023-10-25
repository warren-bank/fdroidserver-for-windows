@echo off

set DIR=%~dp0.
set BIN=%DIR%\..\..\bin

call "%DIR%\util\resolve_path.bat" "%BIN%"
set BIN=%resolved_path%

rem :: ----------------------------------------
rem :: add required dependencies to environment
rem :: ----------------------------------------
set NIRCMD_HOME=%BIN%\fix-extracted-virtualenv-7z-deps\nircmd\2.86
set PATH=%NIRCMD_HOME%;%PATH%
