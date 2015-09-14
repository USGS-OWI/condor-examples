:: file name: sleep.bat
@echo off

set TIMETOWAIT=60
echo sleeping for %TIMETOWAIT% seconds
choice /D Y /T %TIMETOWAIT% > NUL
