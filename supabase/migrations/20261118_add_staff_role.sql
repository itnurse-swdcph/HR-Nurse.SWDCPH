-- Role labels used to exclude nursing leadership from manpower totals.
-- Existing personnel remain NULL until their role is reviewed in the UI.
alter table public.personnel
  add column if not exists staff_role text;

comment on column public.personnel.staff_role is
  'บทบาทเจ้าหน้าที่: หัวหน้าพยาบาล, หัวหน้ากลุ่มงาน, หัวหน้างาน หรือ ผู้ปฏิบัติ';
