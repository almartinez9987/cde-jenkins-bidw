@ECHO off
SET APPNAME=reports_be
SET BRANCH=feature
SET DEPLOY_PATH=D:\releases\%APPNAME%\%BRANCH%
SET CONTROL_PATH=%DEPLOY_PATH%\.control
SET VERSION_MAP_PATH=%DEPLOY_PATH%\.versionmap

:: Extract the feature from the Git Branch that triggered build
for /F "tokens=1,2,3 delims=/" %%a in ("%GIT_BRANCH%") do (
   SET FEATURE=%%c
)

ECHO.
ECHO Staging to release folder...
ECHO.
ECHO release folder     = [%DEPLOY_PATH%]
ECHO control path       = [%CONTROL_PATH%]
ECHO version map path   = [%VERSION_MAP_PATH%]
ECHO VERSION            = [%VERSION%]
ECHO FEATURE            = [%FEATURE%]
ECHO.

:: Make sure the folders exists
IF NOT EXIST "%VERSION_MAP_PATH%" MD %VERSION_MAP_PATH%
IF NOT EXIST "%CONTROL_PATH%"     MD %CONTROL_PATH%

:: Cleanup old files
IF EXIST "buildname.txt" DEL buildname.txt /F /Q
IF EXIST "%VERSION_MAP_PATH%\%FEATURE%.txt" DEL %VERSION_MAP_PATH%\%FEATURE%.txt /F /Q

:: Deploy the artifacts
XCOPY .\artifacts\*.* %DEPLOY_PATH% /Y /R /S /E /Q

ECHO %VERSION% > %CONTROL_PATH%\be.lastbuild.txt

:: Create the build name file to set the build number later
ECHO %FEATURE% - %VERSION% > buildname.txt

:: Save the mapping of the version to the feature
ECHO %APPNAME%_%VERSION% >> %VERSION_MAP_PATH%\%FEATURE%.txt

ECHO.
ECHO Staging completed successfully
ECHO.

