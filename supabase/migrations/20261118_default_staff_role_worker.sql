-- Initialize every current record to the requested baseline role, then apply it to new rows.
update public.personnel
set staff_role = 'ผู้ปฏิบัติ';

alter table public.personnel
  alter column staff_role set default 'ผู้ปฏิบัติ',
  alter column staff_role set not null;
