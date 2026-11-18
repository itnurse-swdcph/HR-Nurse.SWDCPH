-- Normalize outpatient and emergency nursing units to a parent unit plus sub_unit.
-- Existing sub-unit assignments are preserved when they already use an approved name.
begin;

-- Canonical framework rows for outpatient and emergency nursing.
update public.manpower_targets
set unit_name = 'งานการพยาบาลผู้ป่วยนอก'
where group_name = 'กลุ่มงานการพยาบาลผู้ป่วยนอก'
  and unit_name = 'ผู้ปฏิบัติงานผู้ป่วยนอก'
  and not exists (
    select 1 from public.manpower_targets x
    where x.report_type = manpower_targets.report_type
      and x.source_period = manpower_targets.source_period
      and x.group_name = manpower_targets.group_name
      and x.unit_name = 'งานการพยาบาลผู้ป่วยนอก'
      and x.position = manpower_targets.position
  );

update public.manpower_targets
set unit_name = 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
where group_name = 'กลุ่มงานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
  and unit_name in ('กลุ่มงานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน', 'งานการพยาบาลผู้ป่วยอุบัติเหตุฉุกเฉิน')
  and not exists (
    select 1 from public.manpower_targets x
    where x.report_type = manpower_targets.report_type
      and x.source_period = manpower_targets.source_period
      and x.group_name = manpower_targets.group_name
      and x.unit_name = 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
      and x.position = manpower_targets.position
  );

-- Outpatient: all clinics belong to the outpatient parent unit.
update public.personnel
set sub_unit = case
      when unit in ('คลินิกโรคเรื้อรัง', 'คลินิกให้คำปรึกษา', 'คลินิกฝากครรภ์') then unit
      when sub_unit in ('งานการพยาบาลผู้ป่วยนอก', 'คลินิกโรคเรื้อรัง', 'คลินิกให้คำปรึกษา', 'คลินิกฝากครรภ์') then sub_unit
      else 'งานการพยาบาลผู้ป่วยนอก'
    end,
    unit = 'งานการพยาบาลผู้ป่วยนอก'
where unit in (
  'กลุ่มงานการพยาบาลผู้ป่วยนอก', 'งานการพยาบาลผู้ป่วยนอก', 'ผู้ปฏิบัติงานผู้ป่วยนอก',
  'คลินิกโรคเรื้อรัง', 'คลินิกให้คำปรึกษา', 'คลินิกฝากครรภ์'
);

-- Emergency: correct the historical spelling and preserve each team's former unit as sub_unit.
update public.personnel
set sub_unit = case
      when unit in (
        'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน', 'งานการพยาบาลผู้ป่วยอุบัติเหตุฉุกเฉิน',
        'งานEMS', 'งาน EMS', 'ศูนย์รับส่งต่อ', 'ศูนย์เปล'
      ) then case when unit = 'งาน EMS' then 'งานEMS' else unit end
      when sub_unit in (
        'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน', 'งานการพยาบาลผู้ป่วยอุบัติเหตุฉุกเฉิน',
        'งานEMS', 'งาน EMS', 'ศูนย์รับส่งต่อ', 'ศูนย์เปล'
      ) then case when sub_unit in ('งาน EMS', 'งานEMS') then 'งานEMS'
                  when sub_unit = 'งานการพยาบาลผู้ป่วยอุบัติเหตุฉุกเฉิน' then 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
                  else sub_unit end
      else 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
    end,
    unit = 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
where unit in (
  'กลุ่มงานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน',
  'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน', 'งานการพยาบาลผู้ป่วยอุบัติเหตุฉุกเฉิน',
  'งานEMS', 'งาน EMS', 'ศูนย์รับส่งต่อ', 'ศูนย์เปล'
);

-- Keep unit-scoped profiles aligned with the corrected emergency-unit name.
update public.profiles
set unit = 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
where unit = 'งานการพยาบาลผู้ป่วยอุบัติเหตุฉุกเฉิน';

commit;
