-- ============================================
-- 学院 v2 升级：多学院支持
-- 排行榜(leaderboard)和留言(feedback)按学院分开
--   python    = 拉里·佩奇 Python 学院
--   calculus  = 笛卡尔的普林斯顿微积分学院
-- 账号/用户名/头像(profiles)全局共享
-- 幂等：可整段重跑
-- 在 Supabase 控制台 → SQL Editor → 粘贴 → Run
-- ============================================

-- 1️⃣ leaderboard 加学院标识列
alter table public.leaderboard add column if not exists app text not null default 'python';

-- 主键从 (user_id) 升级为 (app, user_id)，两个学院互不覆盖
alter table public.leaderboard drop constraint if exists leaderboard_pkey;
alter table public.leaderboard add primary key (app, user_id);

-- 2️⃣ feedback 加学院标识列
alter table public.feedback add column if not exists app text not null default 'python';

-- 已有留言默认归 python 学院（本来就是在 Python 学院发的）
update public.feedback set app = 'python' where app is null;
update public.leaderboard set app = 'python' where app is null;
