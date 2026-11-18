-- The source workbook's practitioner labels are display labels, not reliable unit keys.
-- Restore each row's scope from the Sheet2 hierarchy so actual counts match personnel.unit/sub_unit.
update public.manpower_analysis_rows as r
set scope_unit = v.scope_unit,
    scope_type = v.scope_type
from (values
  (6,  'งานการพยาบาลผู้ป่วยนอก', 'unit'),
  (7,  'คลินิกโรคเรื้อรัง', 'unit'),
  (8,  'คลินิกให้คำปรึกษา', 'unit'),
  (9,  'คลินิกฝากครรภ์', 'unit'),
  (13, null, 'group'),
  (17, null, 'group'),
  (21, null, 'group'),
  (25, null, 'group'),
  (28, 'งานการพยาบาลด้านการควบคุมและป้องกันการติดเชื้อ', 'unit'),
  (29, 'หน่วยจ่ายกลาง', 'unit'),
  (33, null, 'group'),
  (37, null, 'group'),
  (38, null, 'group'),
  (42, 'งานการพยาบาลไตเทียม', 'unit'),
  (43, 'งานการพยาบาลตรวจด้วยการส่องกล้อง', 'unit'),
  (44, 'งานการพยาบาลเคมีบำบัด', 'unit'),
  (49, 'งานการพยาบาลผู้ป่วยหนัก', 'unit'),
  (52, 'งานการพยาบาลทารกแรกเกิดระยะวิกฤติและทารกป่วย', 'unit'),
  (57, 'งานการพยาบาลผู้ป่วยในหลอดเลือดสมอง+อายุรกรรม 3', 'unit'),
  (60, 'งานการพยาบาลผู้ป่วยในอายุรกรรมหญิง', 'unit'),
  (63, 'งานการพยาบาลผู้ป่วยในอายุรกรรมชาย', 'unit'),
  (66, 'งานการพยาบาลผู้ป่วยในพิเศษปาริฉัตร', 'unit'),
  (69, 'งานการพยาบาลผู้ป่วยในสงฆ์อาพาธ', 'unit'),
  (73, null, 'group'),
  (78, 'งานการพยาบาลผู้ป่วยในสูติ-นรีเวชกรรม', 'unit'),
  (81, 'งานการพยาบาลผู้ป่วยในพิเศษพวงชมพู', 'unit'),
  (85, null, 'group'),
  (86, null, 'group')
) as v(sort_order, scope_unit, scope_type)
where r.sort_order = v.sort_order
  and r.row_type = 'practitioner';
