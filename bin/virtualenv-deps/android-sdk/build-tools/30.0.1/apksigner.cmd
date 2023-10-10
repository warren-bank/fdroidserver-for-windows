@echo off

rem :: --------------------
rem :: add Java JDK to PATH
rem :: --------------------
call "%~dp0..\..\..\..\..\scripts\cmd\virtualenv-env.bat"

java.exe -jar "%~dpn0.jar" %*
