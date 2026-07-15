@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM robocopy-batch.cmd
REM 1. Accepts -source/-s and -dest/-d command-line flags.
REM 2. Requires an elevated (admin) prompt; exits if not.
REM 3. Detects logical processors (threads) for /MT.
REM 4. Prompts for source paths first (blank line ends), then
REM    the destination, matching robocopy's source-then-dest order.
REM 5. Strips surrounding quotes from pasted paths (Explorer
REM    "Copy as path" wraps paths in double quotes).
REM 6. Always uses backup mode (/B).
REM 7. Logs to a timestamped file in the destination folder and
REM    mirrors output to the console via /TEE.
REM ============================================================

set /a COUNT=0
set "DEST_BASE="

REM --- Parse command-line arguments; the tilde modifier strips quotes ---
:parse_args
if "%~1"=="" goto args_done
if /i "%~1"=="-source" goto opt_source
if /i "%~1"=="-s"      goto opt_source
if /i "%~1"=="-dest"   goto opt_dest
if /i "%~1"=="-d"      goto opt_dest
if /i "%~1"=="-help"   goto usage
if /i "%~1"=="-h"      goto usage
if /i "%~1"=="/?"      goto usage
echo Unknown argument: %~1
shift
goto parse_args

:opt_source
if "%~2"=="" (
    echo ERROR: -source requires a value.
    goto usage
)
set /a COUNT+=1
set "SRC[!COUNT!]=%~2"
shift
shift
goto parse_args

:opt_dest
if "%~2"=="" (
    echo ERROR: -dest requires a value.
    goto usage
)
set "DEST_BASE=%~2"
shift
shift
goto parse_args

:args_done

REM --- Require elevation; net session fails for non-admins ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script must be run from an elevated ^(Administrator^) prompt.
    echo Right-click and choose "Run as administrator".
    exit /b 1
)

REM --- Detect number of logical processors (threads) ---
set "THREADS=%NUMBER_OF_PROCESSORS%"
if %THREADS% GTR 128 set "THREADS=128"
if %THREADS% LSS 1 set "THREADS=1"

echo Detected %NUMBER_OF_PROCESSORS% logical processors. Using /MT:%THREADS%.
echo.

REM --- Collect source paths first (like robocopy). Skip if given on CLI. ---
if %COUNT% GTR 0 goto have_sources
echo Enter source paths, one per line.
echo Press ENTER on a blank line to finish.
echo.
:read_loop
set "line="
set /p "line=Source: "
if not defined line goto have_sources
REM Strip any double quotes pasted from Explorer "Copy as path"
set "line=!line:"=!"
if not defined line goto read_loop
set /a COUNT+=1
set "SRC[!COUNT!]=!line!"
goto read_loop
:have_sources
if %COUNT%==0 (
    echo No source paths entered. Exiting.
    goto end
)

REM --- Destination base folder. Skip prompt if given on CLI. ---
if defined DEST_BASE goto have_dest
:dest_loop
set "DEST_BASE="
set /p "DEST_BASE=Destination base folder: "
if not defined DEST_BASE (
    echo Destination cannot be blank.
    goto dest_loop
)
REM Strip any double quotes pasted from Explorer "Copy as path"
set "DEST_BASE=!DEST_BASE:"=!"
if not defined DEST_BASE (
    echo Destination cannot be blank.
    goto dest_loop
)
:have_dest

REM --- Strip a trailing backslash if present, for clean joins ---
if "%DEST_BASE:~-1%"=="\" set "DEST_BASE=%DEST_BASE:~0,-1%"

REM --- Ensure destination base exists so the log path is valid ---
if not exist "%DEST_BASE%" mkdir "%DEST_BASE%"

REM --- Build a timestamped log file path in the destination ---
REM Uses WMIC for a locale-independent yyyymmdd_hhmmss stamp ---
for /f %%t in ('wmic os get LocalDateTime ^| findstr /r "^[0-9]"') do set "DT=%%t"
set "STAMP=%DT:~0,8%_%DT:~8,6%"
set "LOGFILE=%DEST_BASE%\robocopy_%STAMP%.log"

echo.
echo Logging to: %LOGFILE%
echo Starting %COUNT% robocopy job(s) to %DEST_BASE% ...
echo.

REM --- Loop through each stored source path ---
for /l %%i in (1,1,%COUNT%) do (
    set "SRC=!SRC[%%i]!"

    REM Strip the drive letter + colon, then rebuild under DEST_BASE
    REM e.g. C:\updates -> \updates -> <DEST_BASE>\updates
    set "REL=!SRC:~2!"
    set "DEST=!DEST_BASE!!REL!"

    echo ----------------------------------------------------
    echo Copying: !SRC!
    echo   To:    !DEST!
    echo ----------------------------------------------------

    robocopy "!SRC!" "!DEST!" /B /E /XJ /XA:S /XF *.ost /R:0 /W:0 /MT:%THREADS% /TEE /LOG+:"%LOGFILE%"
)

echo.
echo All jobs complete. Log saved to %LOGFILE%.
goto end

:usage
echo.
echo Usage: robocopy-batch.cmd [-source PATH] [-dest PATH]
echo.
echo   -source, -s   Source path. Repeat the flag for multiple sources.
echo   -dest,   -d   Destination base folder.
echo   -help,   -h   Show this help.
echo.
echo Paths may be quoted or unquoted; surrounding quotes are stripped
echo automatically so paths pasted from Explorer work as-is.
echo.
echo If -source is omitted you are prompted for source paths first, then for
echo the destination, matching robocopy's source-then-destination order.
echo Both flags may be combined for a fully non-interactive run.

:end
endlocal
pause
