@echo off

set DIR=%~dp0.
set BIN=%DIR%\..\..\bin

call "%DIR%\util\resolve_path.bat" "%BIN%"
set BIN=%resolved_path%

rem :: ----------------------------------------
rem :: add required dependencies to environment
rem :: ----------------------------------------
set ANDROID_HOME=%BIN%\virtualenv-deps\android-sdk
set PATH=%ANDROID_HOME%\build-tools\30.0.1;%PATH%

rem :: ---------------------------------------------------------------
rem :: external dependency
rem :: ---------------------------------------------------------------
rem :: see:
rem ::   https://portableapps.com/apps/utilities/jdkportable
rem :: ---------------------------------------------------------------
set JAVA_HOME=C:\PortableApps\Java_JDK\8u381
set PATH=%JAVA_HOME%\bin;%PATH%
