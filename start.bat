@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

rem ===========================================================================
rem  McDonald's Radar Map - one-click launcher (Windows)
rem  Double-click this file. It will:
rem    1. locate (or create) the Python venv
rem    2. install the two runtime deps if missing
rem    3. start the local server and open the browser
rem  All friendly messages are printed by Python (src/serve.py) to avoid
rem  codepage issues with non-ASCII text inside a .bat file.
rem ===========================================================================

echo.
echo   McDonald's Radar Map  /  launching ...
echo   ------------------------------------------------------------

set "VENV_PY=%CD%\.venv\Scripts\python.exe"
set "BOOT_PY="

if exist "%VENV_PY%" set "BOOT_PY=%VENV_PY%"
if not defined BOOT_PY (
  py -3 -c "import sys" >nul 2>nul && set "BOOT_PY=py -3"
)
if not defined BOOT_PY (
  python -c "import sys" >nul 2>nul && set "BOOT_PY=python"
)
if not defined BOOT_PY (
  echo.
  echo   [x] Python not found.
  echo       Please install Python 3.10+ from https://www.python.org/downloads/
  echo       and tick "Add Python to PATH" during setup.
  echo.
  pause
  exit /b 1
)

if exist "%VENV_PY%" goto :deps

echo   [1/3] First run: creating virtual environment .venv ...
%BOOT_PY% -m venv .venv
if errorlevel 1 (
  echo.
  echo   [x] Failed to create the virtual environment.
  echo       Make sure your Python install includes the venv module.
  echo.
  pause
  exit /b 1
)
set "VENV_PY=%CD%\.venv\Scripts\python.exe"

:deps
"%VENV_PY%" -c "import mcp, dotenv" >nul 2>nul
if not errorlevel 1 goto :launch

echo   [2/3] Installing dependencies (mcp, python-dotenv) ...
"%VENV_PY%" -m pip install --upgrade pip >nul 2>&1
"%VENV_PY%" -m pip install -r requirements.txt
if errorlevel 1 (
  echo.
  echo   [x] Dependency install failed. Check your network and try again.
  echo.
  pause
  exit /b 1
)

:launch
echo   [3/3] Starting local server, your browser will open shortly ...
"%VENV_PY%" -m src.serve %*
if errorlevel 1 (
  echo.
  echo   [x] The server exited with an error. See the messages above.
  echo.
  pause
)
endlocal
