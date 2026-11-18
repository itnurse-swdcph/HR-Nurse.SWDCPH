-- Split the generic temporary employee position when the employment type identifies its period.
update public.personnel
set position = case
  when type ilike '%รายวัน%' then 'ลูกจ้างชั่วคราวรายวัน'
  when type ilike '%รายเดือน%' then 'ลูกจ้างชั่วคราวรายเดือน'
  else position
end
where regexp_replace(trim(coalesce(position, '')), '\s+', '', 'g') = 'ลูกจ้างชั่วคราว'
  and (type ilike '%รายวัน%' or type ilike '%รายเดือน%');
