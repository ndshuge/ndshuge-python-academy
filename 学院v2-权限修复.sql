-- ============================================
-- 修复：新表缺少角色权限（permission denied 修复）
-- 原因：SQL Editor 建的 profiles/leaderboard/feedback 默认没授权给 anon/authenticated
-- 幂等：可整段重跑
-- 在 Supabase 控制台 → SQL Editor → 粘贴 → Run
-- ============================================

-- 1️⃣ 授予 API 角色访问权限（关键修复）
grant usage on schema public to anon, authenticated;

grant select, insert, update, delete on public.progress to anon, authenticated;
grant select, insert, update, delete on public.profiles to anon, authenticated;
grant select, insert, update, delete on public.leaderboard to anon, authenticated;
grant select, insert, update, delete on public.feedback to anon, authenticated;

grant usage on all sequences in schema public to anon, authenticated;

-- 2️⃣ 顺带确认多学院 app 列（幂等，已加过会跳过）
alter table public.leaderboard add column if not exists app text not null default 'python';
alter table public.leaderboard drop constraint if exists leaderboard_pkey;
alter table public.leaderboard add primary key (app, user_id);

alter table public.feedback add column if not exists app text not null default 'python';

-- 3️⃣ 校验：跑完应能看到四张表
select table_name, grantee, privilege_type
from information_schema.role_table_grants
where table_name in ('progress','profiles','leaderboard','feedback')
  and grantee in ('anon','authenticated')
order by table_name, grantee;
