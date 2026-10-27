-- HR Nurse SWDCPH — Supabase schema. วางใน Dashboard → SQL Editor แล้วกด Run
create table if not exists profiles(user_id uuid primary key references auth.users on delete cascade, role text not null default 'viewer', unit text not null default '-'); -- role: admin|unit_head|viewer, unit: ชื่อหน่วย หรือ *
create table if not exists personnel(id uuid primary key default gen_random_uuid(), prefix text, name text not null, position text, level text, type text, unit text not null,
 start_date date, birth_date date, status text not null default 'active', exit_date date, exit_reason text, created_at timestamptz default now());
create table if not exists events(id bigint generated always as identity primary key, type text not null, person_id uuid references personnel(id), from_unit text, to_unit text,
 effective_date date, reason text, created_by uuid default auth.uid(), created_at timestamptz default now());
create table if not exists framework(unit text not null, position text not null, quota int not null default 0, primary key(unit,position));

create or replace function my_role() returns text language sql stable security definer set search_path=public as $$ select coalesce((select role from profiles where user_id=auth.uid()),'none') $$;
create or replace function my_unit() returns text language sql stable security definer set search_path=public as $$ select coalesce((select unit from profiles where user_id=auth.uid()),'-') $$;
create or replace function can_write(u text) returns boolean language sql stable set search_path=public as $$ select my_role() in ('admin','unit_head') and (my_unit()='*' or my_unit()=u) $$;

revoke execute on function my_role(), my_unit(), can_write(text) from anon, public;
grant execute on function my_role(), my_unit(), can_write(text) to authenticated;

alter table profiles enable row level security; alter table personnel enable row level security; alter table events enable row level security; alter table framework enable row level security;
create policy p_self on profiles for select to authenticated using (user_id=auth.uid());
create policy per_sel on personnel for select to authenticated using (my_role()<>'none' and (my_unit()='*' or unit=my_unit()));
create policy per_ins on personnel for insert to authenticated with check (can_write(unit));
create policy per_upd on personnel for update to authenticated using (can_write(unit)) with check (can_write(unit));
create policy ev_sel on events for select to authenticated using (my_role()<>'none');
create policy ev_ins on events for insert to authenticated with check (my_role() in ('admin','unit_head'));
create policy fw_sel on framework for select to authenticated using (my_role()<>'none');
create policy fw_all on framework for all to authenticated using (my_role()='admin') with check (my_role()='admin');

-- หลังสร้างผู้ใช้ 11450@swdcph.app ใน Authentication → Users (ติ๊ก Auto Confirm) ให้รันบรรทัดนี้:
-- insert into profiles(user_id,role,unit) select id,'admin','*' from auth.users where email='11450@swdcph.app' on conflict (user_id) do update set role='admin',unit='*';
