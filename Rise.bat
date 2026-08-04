@echo off
rem Starts the Rise launcher with no console window.
rem Uses the bundled runtime when it is already installed, otherwise falls back to a
rem system Java just long enough for the launcher to install the bundled one.

set "ROOT=%~dp0"
set "JW=%ROOT%java\bin\javaw.exe"
if not exist "%JW%" set "JW=javaw.exe"

start "" "%JW%" -jar "%ROOT%RiseLauncher.jar"
