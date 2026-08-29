@echo off
title 鼠哥 Python 学院一键推送
cd /d "%~dp0"
set "TOKEN="
for /f "delims=" %%i in ('powershell -NoProfile -Command "& { $m = Select-String -LiteralPath 'E:\Hanako的记忆\学习计划\学习\数学\高数教材\部署备忘-普林斯顿学院.md' -Pattern 'ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+' -AllMatches; $m.Matches[0].Value }"') do set "TOKEN=%%i"
set HTTPS_PROXY=http://127.0.0.1:7897
set HTTP_PROXY=http://127.0.0.1:7897

if "%TOKEN%"=="" (
  echo [错误] 未能读取令牌。
  pause
  exit /b 1
)
echo ==========================================
echo   鼠哥 Python 学院一键推送
echo ==========================================
if not exist .git (git init >nul 2>&1)
git branch -M main 2>nul
echo [1/3] 提交本地改动...
git add .
git -c user.name=ndshuge-cloud -c user.email=ndshuge@gmail.com commit -m "update" >nul 2>&1
echo [%(l)s] 推送...
git remote remove origin 2>nul
git remote add origin "%(u)s" >nul 2>&1
git remote set-url origin "%(u)s" >nul 2>&1

set HTTPS_PROXY=
set HTTP_PROXY=
git push -u origin main 2>err1.txt
set RES=%errorlevel%
if not "%RES%"=="0" (
  echo   直连失败，改用代理重试...
  set HTTPS_PROXY=http://127.0.0.1:7897
  set HTTP_PROXY=http://127.0.0.1:7897
  git push -u origin main 2>err1.txt
  set RES=%errorlevel%
)
if not "%RES%"=="0" (
  echo   推送被拒，强制覆盖中...
  git push -f -u origin main 2>err1.txt
  set RES=%errorlevel%
  if not "%RES%"=="0" (
    set HTTPS_PROXY=http://127.0.0.1:7897
    set HTTP_PROXY=http://127.0.0.1:7897
    git push -f -u origin main 2>err1.txt
    set RES=%errorlevel%
  )
)
git remote set-url origin "https://github.com/ndshuge/ndshuge-python-academy.git" >nul 2>&1
if "%RES%"=="0" ( echo   Python推送成功 ) else ( echo   Python推送失败 & type err1.txt )

del err1.txt >nul 2>&1
echo.
echo ==========================================
echo   Python:  https://ndshuge.github.io/ndshuge-python-academy/
echo ==========================================
pause
