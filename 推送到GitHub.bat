@echo off
title 拉里佩奇 Python 学院 - 一键推送（自动认证）
cd /d "%~dp0"

rem 从普林斯顿部署备忘自动提取令牌
set "TOKEN="
for /f "delims=" %%i in ('powershell -NoProfile -Command "& { $m = Select-String -LiteralPath 'E:\Hanako的记忆\学习计划\学习\数学\高数教材\部署备忘-普林斯顿学院.md' -Pattern 'ghp_[A-Za-z0-9]+' -AllMatches; $m.Matches[0].Value }"') do set "TOKEN=%%i"

if "%TOKEN%"=="" (
  echo [错误] 未能读取令牌。
  pause
  exit /b 1
)

set "REPO=https://github.com/ndshuge-cloud/larry-page-python-academy.git"

echo ==========================================
echo   拉里佩奇 Python 学院 · 一键推送
echo ==========================================
echo.

if not exist .git (git init >nul 2>&1)
git branch -M main 2>nul

echo [1/3] 提交本地改动...
git add .
git -c user.name=ndshuge-cloud -c user.email=ndshuge@gmail.com commit -m "更新学院内容" >nul 2>&1

echo [2/3] 设置远程并推送...
git remote remove origin 2>nul
git remote add origin "https://ndshuge-cloud:%TOKEN%@github.com/ndshuge-cloud/larry-page-python-academy.git" >nul 2>&1
git remote set-url origin "https://ndshuge-cloud:%TOKEN%@github.com/ndshuge-cloud/larry-page-python-academy.git" >nul 2>&1
git push -u origin main 2>push_err.txt
set ERR=%errorlevel%

rem 如果推送被拒（本地与远程历史不同步），本地为最新权威，强制覆盖
findstr /i "rejected fetch first" push_err.txt >nul 2>&1
if %errorlevel%==0 (
  echo 检测到远程与本地不同步，本地为最新版，强制覆盖推送...
  git push -f -u origin main 2>push_err.txt
  set ERR=%errorlevel%
)

rem 还原 remote，不留令牌痕迹
git remote set-url origin "%REPO%" >nul 2>&1

if %ERR%==0 (
  echo.
  echo ==========================================
  echo   [3/3] 推送成功！
  echo   仓库：https://github.com/ndshuge-cloud/larry-page-python-academy
  echo   网页：https://ndshuge-cloud.github.io/larry-page-python-academy/
  echo ==========================================
) else (
  echo.
  echo   [3/3] 推送失败，错误信息：
  type push_err.txt
)
del push_err.txt >nul 2>&1
echo.
pause
