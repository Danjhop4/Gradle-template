@echo off
setlocal EnableExtensions

rem ============================================================
rem  Custom Gradle wrapper using command-line JVM path
rem  Usage:
rem      gradle.bat <JVM_PATH> <GRADLE_TASK> [extra args...]
rem ============================================================

rem --- Ensure JVM path was provided ---
if "%~1"=="" (
    echo ERROR: No JVM path provided.
    echo Usage: gradle.bat ^<JVM_PATH^> ^<GRADLE_TASK^> [args...]
    "%COMSPEC%" /c exit 1
)

set JVM_PATH=%~1
shift

rem --- Ensure Gradle command was provided ---
if "%~1"=="" (
    echo ERROR: No Gradle command provided.
    echo Usage: gradle.bat ^<JVM_PATH^> ^<GRADLE_TASK^> [args...]
    "%COMSPEC%" /c exit 1
)

set GRADLE_CMD=%~1
shift

rem --- Resolve script directory ---
set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.
set APP_HOME=%DIRNAME%
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

rem --- JVM executable ---
set JAVA_EXE=%JVM_PATH%\bin\java.exe

if not exist "%JAVA_EXE%" (
    echo ERROR: JVM not found at "%JAVA_EXE%"
    "%COMSPEC%" /c exit 1
)

rem --- Default JVM options ---
set DEFAULT_JVM_OPTS="-Xmx64m" "-Xms64m"

rem --- Execute Gradle ---
endlocal & "%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% ^
    "-Dorg.gradle.appname=gradle" ^
    -jar "%APP_HOME%\gradle\wrapper\gradle-wrapper.jar" ^
    %GRADLE_CMD% %* ^
    & call :exitWithErrorLevel

:exitWithErrorLevel
"%COMSPEC%" /c exit %ERRORLEVEL%
