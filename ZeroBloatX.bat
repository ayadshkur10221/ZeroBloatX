@echo off
:: ZeroBloatX - Automated Registry Tweaker & Advanced Debloater
title ZeroBloatX
setlocal EnableDelayedExpansion

:: --- FORCE CORRECT WORKING DIRECTORY ---
cd /d "%~dp0"

:: --- ADMIN RIGHTS CHECK ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] ZeroBloatX requires Administrator privileges.
    echo [!] Please right-click this script and select "Run as administrator".
    echo.
    pause
    exit /b
)

:: --- INITIALIZATION ---
cls
echo =======================================================
echo                 ZeroBloatX v1.2                        
echo      Purging background bloatware and services         
echo =======================================================
echo.

set "MODULES_DIR=%~dp0modules"

:: Check if the modules folder actually exists
if not exist "%MODULES_DIR%" (
    echo [ERROR] The 'modules' folder was not found at:
    echo "%MODULES_DIR%"
    echo.
    pause
    exit /b
)

echo [*] Target directory found: \modules
echo [*] Preparing to apply registry tweaks...
echo.
choice /M "Do you want to apply all tweaks now"
if %errorlevel% neq 1 (
    echo [!] Operation cancelled by user.
    pause
    exit /b
)

echo.
echo =======================================================
echo             APPLYING REGISTRY MODULES                  
echo =======================================================

set "count=0"
for %%F in ("%MODULES_DIR%\*.reg") do (
    set /a "count+=1"
    echo [!count!] Applying: %%~nxF...
    
    reg import "%%F"
    if !errorLevel! equ 0 (
        echo      - Status: Success
    ) else (
        echo      - Status: Failed Above ^^^
    )
    echo -------------------------------------------------------
)

echo =======================================================
echo.
echo [✓] Done! Attempted to apply !count! registry modules.
echo [!] Note: Restart your PC to fully apply registry changes.
echo.
echo =======================================================
echo              MORE TWEAKS & DEBLOATING                  
echo =======================================================
echo.

choice /M "Would you like to run Chris Titus Tool for advanced tweaks"
if %errorlevel% equ 1 (
    echo.
    echo -------------------------------------------------------
    echo  💡 TIP: When the utility window opens:
    echo  1. Go to the "Tweaks" tab at the top.
    echo  2. Choose what features you want to disable / remove.
    echo  3. Click "Run Tweaks" on the right to apply them!
    echo -------------------------------------------------------
    echo.
    echo [*] Launching Chris Titus Windows Utility via PowerShell...
    echo [*] Please wait a moment for the GUI window to download and pop up...
    
    :: Runs the PowerShell payload safely inside the batch script wrapper
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm christitus.com/win | iex"
) else (
    echo.
    echo [!] Skipping advanced tweaks.
)

echo.
echo =======================================================
echo [✓] ZeroBloatX process finished completely!
echo =======================================================
echo.
pause
exit /b