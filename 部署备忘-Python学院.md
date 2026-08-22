# 拉里·佩奇 Python 学院 · GitHub 部署备忘

> 建立：2026-08-22 | 状态：已上线 | 由拉里·佩奇维护

## 一、最终成果

| 项目 | 地址 |
|---|---|
| **同学访问链接（Pages）** | https://ndshuge-cloud.github.io/larry-page-python-academy/ |
| 仓库（源码） | https://github.com/ndshuge-cloud/larry-page-python-academy |
| GitHub 账号 | ndshuge-cloud（ndshuge@gmail.com） |
| 查看仓库入口 | https://github.com/ndshuge-cloud?tab=repositories |

- 单文件 HTML（含 Pyodide 浏览器内 Python 运行时 + CodeMirror 编辑器），进度存各学习者浏览器 localStorage，互不影响。
- 打开即学，无需登录下载。

## 二、本地工作区对应文件

| 文件 | 路径 |
|---|---|
| 学院源文件 | `E:\Hanako的记忆\学习计划\learn-python\index.html` |
| 部署目录（本地 git 仓库） | `E:\Hanako的记忆\.tmp\deploy-python\` |
| 学习计划 | `学习计划\learn-python\学习计划-Python编程从入门到实践.md` |
| 进度档案 | `学习计划\learn-python\Python之旅-进度.md` |
| 一键推送脚本 | `学习计划\learn-python\推送到GitHub.bat` |

## 三、版权红线（务必遵守）

- 仓库里只放原创内容：HTML 学院、学习计划、进度档案。✅
- **严禁上传**《Python编程从入门到实践》PDF 等整本扫描书——公开仓库会被 GitHub 检测下架甚至封号。只留本地。

## 四、如何更新课程（核心流程）

> **⚠️ 铁律：每次推送完成后，必须在对话里附上同学访问链接**
> `https://ndshuge-cloud.github.io/larry-page-python-academy/`

**方式 A：用户双击脚本（推荐日常用）**
`推送到GitHub.bat` → 自动提交 + 推送。脚本已用 GBK 编码（Windows cmd 才能正确解析中文）。

**方式 B：手动推送（需 Clash 代理 127.0.0.1:7897）**
```powershell
$t='ghp_****（见对话记录，勿写入仓库）'
$env:HTTPS_PROXY='http://127.0.0.1:7897'
$env:HTTP_PROXY='http://127.0.0.1:7897'
cd 'E:\Hanako的记忆\.tmp\deploy-python'
Copy-Item 'E:\Hanako的记忆\学习计划\learn-python\index.html' .\index.html -Force
git add .
git -c user.name=ndshuge-cloud -c user.email=ndshuge@gmail.com commit -m "更新说明"
git remote set-url origin "https://ndshuge-cloud:$t@github.com/ndshuge-cloud/larry-page-python-academy.git"
git push -u origin main
git remote set-url origin 'https://github.com/ndshuge-cloud/larry-page-python-academy.git'
```

**进度兼容守则**：
- 不要改 localStorage 键名（`pyc_lessons` / `pyc_hall` / `pyc_log`），否则同学已有进度丢失。
- 新增章节保持编号不重排。
- 改版前先本地自测。

## 五、令牌管理

- 令牌：`ghp_****（见对话记录，勿写入仓库）`（与微积分学院共用，权限 repo，长期有效）
- 泄露/轮换：GitHub → Settings → Developer settings → Personal access tokens
- remote 地址推完即还原，不留令牌痕迹。

## 六、踩过的坑（复盘）

1. **bat 文件编码**：必须存 **GBK（ANSI）**，UTF-8 会被 cmd 按 GBK 误读，`echo` 变 `cho`、中文乱码、命令碎片被当程序执行。
2. **沙箱审批**：会话环境里外发操作需人工批准——用户需在界面批准框点「批准」（不是对话里回"允许"两个字）。失败就重试，用户批准后放行。
3. **git 直连 GitHub 不稳**：必须走 Clash 代理（127.0.0.1:7897），否则连接被重置。
4. **GitHub Push Protection**：`ghp_` 开头的令牌绝不能写进要提交的文件。
5. **本地 git config 写不进**：用 `git -c user.name=... -c user.email=...` 临时指定。
6. **文件内容会变**：index.html 改动后，先复制到部署目录再 commit，别直接在部署目录里改。
