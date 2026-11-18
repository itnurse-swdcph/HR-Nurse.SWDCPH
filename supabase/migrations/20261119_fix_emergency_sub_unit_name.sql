-- Normalize the former emergency unit spelling in sub_unit as well as unit.
update public.personnel
set sub_unit = 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
where unit = 'งานการพยาบาลผู้ป่วยอุบัติเหตุและฉุกเฉิน'
  and sub_unit = 'งานการพยาบาลผู้ป่วยอุบัติเหตุฉุกเฉิน';
