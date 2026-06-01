@echo off
:: Use %~dp0 to target steamcmd.exe in the same folder as this script
set "SCMD=%~dp0steamcmd.exe"
set "USERNAME={username}"
set "APP_ID=601150"

echo [info] Logging in and downloading App ID %APP_ID%...

:: We wrap the path in quotes to handle any spaces in folder names
"%SCMD%" +login %USERNAME% +app_update %APP_ID% validate +quit

echo [info] Operation update and validate complete.

