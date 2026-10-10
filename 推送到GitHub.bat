@echo off
setlocal EnableExtensions
title Python Academy Safe Push
cd /d "%~dp0"
where git >nul 2>&1
if errorlevel 1 goto ERROR
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 goto ERROR
git remote get-url origin 2>nul | findstr /I /C:"github.com/ndshuge/ndshuge-python-academy" >nul
if errorlevel 1 (
  echo ERROR: unexpected origin repository.
  exit /b 1
)
for /f "delims=" %%B in ('git branch --show-current') do set "BRANCH=%%B"
if "%BRANCH%"=="" goto ERROR
echo Repository: ndshuge/ndshuge-python-academy
echo Branch: %BRANCH%
git status --short
echo New files must be inspected and staged manually; only tracked changes are auto-staged.
choice /C YN /M "Commit tracked changes and push this branch"
if errorlevel 2 exit /b 0
git add -u
git diff --cached --quiet
if errorlevel 2 goto ERROR
if errorlevel 1 (
  git commit -m "chore: update Python Academy"
  if errorlevel 1 goto ERROR
)
git push -u origin HEAD
if errorlevel 1 goto ERROR
echo Push succeeded. No force push was used.
exit /b 0
:ERROR
echo Failed. No force push was attempted. Check credentials, branch and remote.
echo Authenticate with gh auth login or Git Credential Manager.
exit /b 1
