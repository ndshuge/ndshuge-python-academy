@echo off
title 开启 GitHub Pages
cd /d "%~dp0"

rem 从普林斯顿部署备忘自动提取令牌
set "TOKEN="
for /f "delims=" %%i in ('powershell -NoProfile -Command "& { $m = Select-String -LiteralPath 'E:\Hanako的记忆\学习计划\学习\数学\高数教材\部署备忘-普林斯顿学院.md' -Pattern 'ghp_[A-Za-z0-9]+' -AllMatches; $m.Matches[0].Value }"') do set "TOKEN=%%i"

if "%TOKEN%"=="" (
  echo [错误] 未能读取令牌。
  pause
  exit /b 1
)

echo 正在为仓库开启 GitHub Pages...
curl.exe -s -X POST -H "Authorization: token %TOKEN%" -H "Accept: application/vnd.github+json" https://api.github.com/repos/ndshuge-cloud/larry-page-python-academy/pages -d "{\"source\":{\"branch\":\"main\",\"path\":\"/\"}}"

echo.
echo ==========================================
echo   如果上方出现 "id" 和 "html_url" 就是成功了
echo   如果出现 "already been enabled" 说明已开启
echo   如果出现 "Not Found" 请检查仓库名
echo ==========================================
echo   等 1-2 分钟后访问：
echo   https://ndshuge-cloud.github.io/larry-page-python-academy/
echo ==========================================
pause
