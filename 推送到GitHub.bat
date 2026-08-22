@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ==========================================
echo   拉里·佩奇 Python 学院 · 推送到 GitHub
echo ==========================================
echo.

rem 检查仓库状态
if not exist .git (
  echo 初始化仓库...
  git init >nul
)

rem 确保 main 分支
git branch -M main 2>nul

rem 设置远程
git remote remove origin 2>nul
git remote add origin https://github.com/ndshuge-cloud/larry-page-python-academy.git

rem 提交当前改动
git add .
git commit -m "更新学院内容" 2>nul

echo 正在推送到 GitHub...
git push -u origin main

if %errorlevel%==0 (
  echo.
  echo ✅ 推送成功！
  echo    仓库地址：https://github.com/ndshuge-cloud/larry-page-python-academy
  echo    网页地址（GitHub Pages，需在仓库 Settings - Pages 开启）：
  echo    https://ndshuge-cloud.github.io/larry-page-python-academy/
) else (
  echo.
  echo ❌ 推送失败。常见原因与解决：
  echo    1. 远程仓库不存在 → 先到 https://github.com/new 创建空仓库，
  echo       名称填 larry-page-python-academy，创建后重新运行本脚本
  echo    2. 未登录 → 首次推送会弹出 GitHub 登录窗口，登录即可
  echo    3. 网络问题 → 检查网络后重试
)
echo.
pause
