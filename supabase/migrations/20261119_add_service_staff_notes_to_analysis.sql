-- Keep service staff out of the ward-attendant count and show them in Sheet2 notes.
update public.manpower_analysis_rows
set source_note = concat_ws(' · ', nullif(trim(source_note), ''), 'มีพนักงานบริการ 1 คน')
where sort_order in (29, 37)
  and row_type = 'practitioner'
  and source_note not like '%มีพนักงานบริการ 1 คน%';
