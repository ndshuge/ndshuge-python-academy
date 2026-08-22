@echo off
title 鼠哥 Python 学院一键推送
cd /d "%~dp0"
set "TOKEN="
for /f "delims=" %%i in ('powershell -NoProfile -Command "& { $m = Select-String -LiteralPath 'E:\Hanako的记忆\学习计划\学习\数学\高数教材\部署备忘-普林斯顿学院.md' -Pattern 'ghp_[A-Za-z0-9]+' -AllMatches; $m.Matches[0].Value }"') do set "TOKEN=%%i"

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
echo [2/3] 设置远程并推送...
git remote remove origin 2>nul
git remote add origin "https://ndshuge-cloud:%TOKEN%@github.com/ndshuge-cloud/ndshuge-python-academy.git" >nul 2>&1
git remote set-url origin "https://ndshuge-cloud:%TOKEN%@github.com/ndshuge-cloud/ndshuge-python-academy.git" >nul 2>&1
git push -u origin main 2>err.txt
if errorlevel 1 (
  echo   推送被拒，强制覆盖中...
  git push -f -u origin main 2>err.txt
)
git remote set-url origin "https://github.com/ndshuge-cloud/ndshuge-python-academy.git" >nul 2>&1
del err.txt >nul 2>&1
echo.
echo ==========================================
echo   [3/3] 完成！
echo   网页: https://ndshuge-cloud.github.io/ndshuge-python-academy/
echo ==========================================
pause
