@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM robocopy-batch.cmd
REM 1. Requires an elevated (admin) prompt; exits if not.
REM 2. Detects logical processors (threads) for /MT.
REM 3. Prompts for a destination base folder.
REM 4. Prompts for source paths (one per line, blank line ends).
REM 5. Always uses backup mode (/B).
REM 6. Logs to a timestamped file in the destination folder and
REM    mirrors output to the console via /TEE.
REM ============================================================

REM --- Require elevation; net session fails for non-admins ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script must be run from an elevated ^(Administrator^) prompt.
    echo Right-click and choose "Run as administrator".
    exit /b 1
)

REM --- Detect number of logical processors (threads) ---
set "THREADS=%NUMBER_OF_PROCESSORS%"

REM --- robocopy /MT only accepts 1-128, so clamp the value ---
if %THREADS% GTR 128 set "THREADS=128"
if %THREADS% LSS 1 set "THREADS=1"

echo Detected %NUMBER_OF_PROCESSORS% logical processors. Using /MT:%THREADS%.
echo.

REM --- Prompt for destination base folder (re-prompt if blank) ---
:dest_loop
set "DEST_BASE="
set /p "DEST_BASE=Destination base folder: "
if not defined DEST_BASE (
    echo Destination cannot be blank.
    goto dest_loop
)

REM --- Strip a trailing backslash if present, for clean joins ---
if "%DEST_BASE:~-1%"=="\" set "DEST_BASE=%DEST_BASE:~0,-1%"

REM --- Ensure destination base exists so the log path is valid ---
if not exist "%DEST_BASE%" mkdir "%DEST_BASE%"

REM --- Build a timestamped log file path in the destination ---
REM Uses WMIC for a locale-independent yyyymmdd_hhmmss stamp ---
for /f %%t in ('wmic os get LocalDateTime ^| findstr /r "^[0-9]"') do set "DT=%%t"
set "STAMP=%DT:~0,8%_%DT:~8,6%"
set "LOGFILE=%DEST_BASE%\robocopy_%STAMP%.log"

echo Logging to: %LOGFILE%
echo.
echo Enter source paths, one per line.
echo Press ENTER on a blank line to finish.
echo.

REM --- Read source paths into an indexed pseudo-array ---
set /a COUNT=0
:read_loop
set "line="
set /p "line=Source: "
if not defined line goto run
set /a COUNT+=1
set "SRC[!COUNT!]=!line!"
goto read_loop

:run
if %COUNT%==0 (
    echo No source paths entered. Exiting.
    goto end
)

echo.
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

    robocopy "!SRC!" "!DEST!" /B /E /XJ /XA:SH /XF *.ost /R:0 /W:0 /MT:%THREADS% /TEE /LOG+:"%LOGFILE%"
)

echo.
echo All jobs complete. Log saved to %LOGFILE%.

:end
endlocal
pause
