dir

REM First, lets unpack the versions of R and Rtools we brought with us

REM I include the 7zip tool because there's no default installed zip
REM library on Windows
REM could remove the NUL output redirect if you needed to debug things

7z x R.zip > NUL
7z x Rtools.zip > NUL

REM now lets setup the new R portion of the PATH we need
REM NOTE: this blows away the existing PATH for the duration of the condor run
REM other programs installed on the worker machine may not be available

SET rtools_path=%cd%\Rtools\3.2\gcc-4.6.3\bin;%cd%\Rtools\3.2\gcc-4.6.3\i686-w64-mingw32\bin;%cd%\Rtools\3.2\bin;
SET standard_path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;
SET r_path=%cd%\R\bin;

SET PATH=%standard_path%%rtools_path%%r_path%

echo %PATH%

REM Before we run R, we want to setup the rLibs directory so package installs 
REM have somewhere to go

md rLibs

Rscript.exe some_r_code.R