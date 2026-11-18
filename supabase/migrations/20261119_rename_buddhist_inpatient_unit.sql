-- Use the established unit name consistently for Buddhist inpatient nursing.
begin;

update public.manpower_targets
set unit_name = 'งานการพยาบาลผู้ป่วยในสงฆ์อาพาธ'
where group_name = 'กลุ่มงานการพยาบาลผู้ป่วยอายุรกรรม'
  and unit_name = 'งานการพยาบาลผู้ป่วยสงฆ์อาพาธ'
  and not exists (
    select 1
    from public.manpower_targets existing
    where existing.report_type = manpower_targets.report_type
      and existing.source_period = manpower_targets.source_period
      and existing.group_name = manpower_targets.group_name
      and existing.unit_name = 'งานการพยาบาลผู้ป่วยในสงฆ์อาพาธ'
      and existing.position = manpower_targets.position
  );

commit;
