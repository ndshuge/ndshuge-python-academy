# Supabase RLS 安全核验（只读清单）

本仓库保留了早期数据库升级脚本。其中 `学院v2-权限修复.sql` 对 `anon` 与 `authenticated` 授予部分表的读写权限。**这些 GRANT 语句本身不证明出现越权；实际结果同时取决于 RLS、策略和当前用户身份。**

在未验证生产库策略之前，不应直接重跑历史权限修复脚本，也不应声称在线数据库已经通过安全验收。

## 1. 在 Supabase SQL Editor 中执行只读查询

### 检查四张表是否开启 RLS

```sql
select n.nspname as schema_name,
       c.relname as table_name,
       c.relrowsecurity as rls_enabled,
       c.relforcerowsecurity as force_rls
from pg_catalog.pg_class c
join pg_catalog.pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in ('progress', 'profiles', 'leaderboard', 'feedback')
  and c.relkind in ('r', 'p')
order by c.relname;
```

### 检查现有安全策略（仅查看，不修改）

```sql
select schemaname, tablename, policyname, permissive,
       roles, cmd, qual, with_check
from pg_catalog.pg_policies
where schemaname = 'public'
  and tablename in ('progress', 'profiles', 'leaderboard', 'feedback')
order by tablename, policyname;
```

### 检查现有 API 角色权限

```sql
select table_name, grantee, privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name in ('progress', 'profiles', 'leaderboard', 'feedback')
  and grantee in ('anon', 'authenticated')
order by table_name, grantee, privilege_type;
```

## 2. 用测试账号核对真实访问

- 匿名用户：不能读取、修改不应公开的进度与资料
- 用户 A：能读写自己的进度，无法改用户 B 的进度或账号资料
- 用户 B：与 A 对称，无法查看或覆盖 A 的私人学习记录
- 排行榜：按业务要求允许读取必要字段，但不可提交或修改其他用户成绩
- 反馈：根据实际隐私说明验证哪些用户可读、可创建、可删除

这些应在正常 API 访问路径下测试，而不是仅靠管理员 SQL Editor 的查询结果。

## 3. 处理原则

1. 先保存当前策略定义，使用测试项目验证修复。
2. 采用最小权限原则收窄不必要的 GRANT，并确保 RLS 的 `USING` / `WITH CHECK` 约束覆盖全部操作。
3. 不把 `service_role` / secret key 放入静态网页；可发布的 anon/publishable key 不是安全边界。
4. 不把生产账号邮件地址、令牌或未经处理的数据库查询结果发到公开 Issue。

**本文件只是检查清单；没有对 Supabase 线上数据库执行任何查询或迁移。**
