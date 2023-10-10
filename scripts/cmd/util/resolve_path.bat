@echo off

set resolved_path=%~1

if not exist "%resolved_path%" goto :done

set _cd=%cd%
cd /D "%resolved_path%"
set resolved_path=%cd%
cd /D "%_cd%"
set _cd=

:done
