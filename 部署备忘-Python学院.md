# Python 学院｜部署和权限备忘

> 本文档替换了包含旧账号、旧本机路径与不安全 Token 用法的历史备忘。请勿将任何 GitHub Personal Access Token 写入脚本、Git URL 或仓库文件。

## 正式入口

- [源码仓库](https://github.com/ndshuge/ndshuge-python-academy)
- [GitHub Pages](https://ndshuge.github.io/ndshuge-python-academy/)
- [Pages 设置](https://github.com/ndshuge/ndshuge-python-academy/settings/pages)

## 正常部署

1. 在 Windows 上使用 GitHub CLI 或 Git Credential Manager 登录；如使用 CLI，可通过 `gh auth login` 完成登录。
2. 检查 `git status` 与 `git diff`；不要提交 API Key、账号令牌、个人隐私或本机临时文件。
3. `git add -u` 暂存已跟踪文件；新增文件人工检查后再 `git add <path>`。
4. `git commit -m "chore: update Python Academy"`。
5. `git push -u origin HEAD`。如果远端拒绝推送，先同步并解决冲突，**绝不把强制推送当作自动回退**。

根目录的 `推送到GitHub.bat` 会检查远程仓库和当前分支、显示变更并要求确认；`开启Pages.bat` 仅打开设置页，不使用 Token。

## Supabase 权限核验

`学院v2-SQL建表.sql`、`学院v2-多学院升级.sql`、`学院v2-权限修复.sql` 是历史迁移资料，**不代表线上正在启用的 RLS 策略，也不应直接重复执行**。

上线前必须分别以匿名用户、用户 A、用户 B 核验：

- `profiles` 写入只能修改自己的记录；公开个人信息需最小化。
- `leaderboard` 只能修改自己的成绩；公共排行只暴露必要字段。
- `feedback` 的公开读取范围与真实的隐私说明保持一致。
- `progress` 等个人学习数据需启用、验证行级安全（RLS）。
- 前端不得包含 `service_role` / `sb_secret_` 等服务端密钥。可发布的前端 API Key 不能代替 RLS。

## 验收清单

- 无痕窗口打开 Pages 页面，确认资源正确加载。
- 使用两个测试账号模拟同步和跨账号读写，检查数据隔离。
- 移动端完成账号登录、进度保存和退出登录。
- 如果旧版脚本或历史 Git 提交曾包含真实令牌，须在 GitHub 账户设置中撤销并轮换。
