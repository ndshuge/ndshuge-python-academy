@echo off
title 拉里佩奇 Python 学院 - 推送到 GitHub
echo ==========================================
echo   拉里佩奇 Python 学院 · 一键推送
echo ==========================================
echo.

if not exist .git (
  echo [1/4] 初始化本地仓库...
  git init >nul 2>&1
  git branch -M main 2>nul
)

git branch -M main 2>nul
git remote remove origin 2>nul
git remote add origin https://github.com/ndshuge-cloud/larry-page-python-academy.git
git add .
git commit -m "更新学院内容" >nul 2>&1

echo [2/4] 正在推送到 GitHub...
echo.

:push
git push -u origin main 2>push_err.txt
set ERR=%errorlevel%

findstr /i "repository not found" push_err.txt >nul 2>&1
if %errorlevel%==0 goto norepo

if %ERR%==0 goto ok

echo [3/4] 推送出错，信息如下：
type push_err.txt
echo.
echo 请把上面的文字发给助手，或检查网络后按任意键重试。
pause >nul
goto push

:norepo
echo [3/4] 远程仓库还不存在，正在为你打开创建页面...
start https://github.com/new
echo.
echo   在打开的页面里：
echo     名称填：larry-page-python-academy
echo     可见性选 Public，下面什么都不要勾
echo     点绿色 Create repository
echo.
echo   创建完成后，回到本窗口按任意键继续推送...
pause >nul
goto push

:ok
del push_err.txt >nul 2>&1
echo.
echo [4/4] 推送成功！
echo   仓库地址：https://github.com/ndshuge-cloud/larry-page-python-academy
echo   在线网页（需在仓库 Settings-Pages 开启）：
echo   https://ndshuge-cloud.github.io/larry-page-python-academy/
echo.
pause
