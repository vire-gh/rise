@echo off
setlocal enabledelayedexpansion
title Demise (no-exe launcher)

cd /d "%~dp0"
set "ROOT=%~dp0"

rem --- Locate Java 17 (the jar is compiled for Java 17). Override with JAVA17_HOME. ---
set "JDK="
if defined JAVA17_HOME if exist "%JAVA17_HOME%\bin\java.exe" set "JDK=%JAVA17_HOME%"
if not defined JDK (
  for %%D in (
    "C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot"
    "C:\Program Files\Java\jdk-17"
    "C:\Program Files\Java\jdk-21"
    "C:\Program Files\Java\jdk-25.0.2"
  ) do if not defined JDK if exist "%%~D\bin\java.exe" set "JDK=%%~D"
)
if not defined JDK (
  echo [ERROR] Java 17+ not found. Install Java 17, or set JAVA17_HOME to its folder.
  pause & exit /b 1
)
set "JAVA=%JDK%\bin\java.exe"

if not exist "%ROOT%demise.jar"  ( echo [ERROR] demise.jar missing next to this script. & pause & exit /b 1 )
if not exist "%ROOT%natives\lwjgl.dll" ( echo [ERROR] natives\ folder missing. & pause & exit /b 1 )
if not exist "%ROOT%data"    mkdir "%ROOT%data"
if not exist "%ROOT%assets"  mkdir "%ROOT%assets"

echo Using Java : %JDK%
echo Launching Demise (offline; sign in with Microsoft inside the client)...
echo.

rem  -cp (not -jar): the fat jar's manifest has no Main-Class.
rem  --add-opens: modern Java locks down reflection that 1.8 Minecraft relies on.
rem  org.lwjgl.librarypath: load the natives we extracted flat into .\natives
"%JAVA%" -Xmx6G -Xms2G ^
  --add-opens java.base/java.lang=ALL-UNNAMED ^
  --add-opens java.base/java.lang.reflect=ALL-UNNAMED ^
  --add-opens java.base/java.util=ALL-UNNAMED ^
  --add-opens java.base/java.io=ALL-UNNAMED ^
  --add-opens java.base/java.nio=ALL-UNNAMED ^
  --add-opens java.base/java.net=ALL-UNNAMED ^
  --add-opens java.base/java.text=ALL-UNNAMED ^
  --add-opens java.desktop/java.awt=ALL-UNNAMED ^
  --add-opens java.desktop/sun.awt=ALL-UNNAMED ^
  -Dorg.lwjgl.librarypath="%ROOT%natives" ^
  -Djava.library.path="%ROOT%natives" ^
  -cp "%ROOT%demise.jar" ^
  net.minecraft.client.main.Main ^
  --username C0ROUTINE ^
  --version demise ^
  --gameDir "%ROOT%data" ^
  --assetsDir "%ROOT%assets" ^
  --assetIndex 1.8 ^
  --uuid 00000000000000000000000000000000 ^
  --accessToken 0 ^
  --userProperties {} ^
  --userType legacy ^
  --width 854 --height 480

echo.
echo Demise exited with code %ERRORLEVEL%.
pause
endlocal
