-- ============================================
-- 拉里·佩奇 Python 学院 v2：用户名 / 头像 / 排行榜 / 留言
-- 留言版升级：全员可见、强制实名（防匿名）、显示时间
-- 幂等版：所有策略先删后建，之前跑过任何版本都能整段重跑
-- 在 Supabase 控制台 → SQL Editor → 新建查询 → 粘贴 → Run
-- ============================================

-- 1️⃣ 用户资料表（用户名 + 头像）
create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  avatar text not null default '🦊',
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profiles_select_all" on public.profiles;
drop policy if exists "profiles_insert_own" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;

create policy "profiles_select_all" on public.profiles
  for select using (true);
create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = user_id);
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = user_id);

-- 2️⃣ 排行榜表（只存展示数据，不含任何隐私）
create table if not exists public.leaderboard (
  user_id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  avatar text not null default '🦊',
  pct int not null default 0,
  done int not null default 0,
  lessons int not null default 0,
  rank_name text not null default '终端学徒',
  updated_at timestamptz not null default now()
);

alter table public.leaderboard enable row level security;

drop policy if exists "leaderboard_select_all" on public.leaderboard;
drop policy if exists "leaderboard_upsert_own" on public.leaderboard;

create policy "leaderboard_select_all" on public.leaderboard
  for select using (true);
create policy "leaderboard_upsert_own" on public.leaderboard
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 3️⃣ 留言表（给作者的建议、想说的话）
--    强制实名：必须登录、user_id 必须是本人、用户名/头像由触发器从 profiles 取
create table if not exists public.feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  username text not null,
  avatar text not null default '🦊',
  content text not null,
  created_at timestamptz not null default now()
);

alter table public.feedback enable row level security;

drop policy if exists "feedback_insert_all" on public.feedback;
drop policy if exists "feedback_insert_own" on public.feedback;
drop policy if exists "feedback_select_all" on public.feedback;

-- 只能登录用户发言，且 user_id 必须是本人（无法匿名）
create policy "feedback_insert_own" on public.feedback
  for insert with check (auth.uid() = user_id);
create policy "feedback_select_all" on public.feedback
  for select using (true);

-- 触发器：发言时强制用 profiles 里的真实用户名/头像，忽略前端传入值
create or replace function public.fb_enforce_identity()
returns trigger language plpgsql security definer as $$
declare p record;
begin
  select username, avatar into p from public.profiles where user_id = new.user_id;
  if found then
    new.username := p.username;
    new.avatar := p.avatar;
  else
    new.username := '同学';
    new.avatar := '🦊';
  end if;
  return new;
end $$;

drop trigger if exists trg_fb_identity on public.feedback;
create trigger trg_fb_identity before insert on public.feedback
  for each row execute function public.fb_enforce_identity();
