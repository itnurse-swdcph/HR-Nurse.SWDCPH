# HR Nurse SWDCPH
ระบบบันทึกเข้า-ออกบุคลากรทางการพยาบาล + แดชบอร์ดผู้บริหาร (กลุ่มการพยาบาล รพ.สมเด็จพระยุพราชสว่างแดนดิน)

**สถาปัตยกรรม:** `index.html` (GitHub Pages) → Supabase (Auth + Postgres + RLS)

## ติดตั้ง
1. Supabase Dashboard → SQL Editor → รัน `supabase/schema.sql`
2. Authentication → Providers → Email: ปิด "Confirm email" และตั้ง **Minimum password length = 5** (เพื่อให้ใช้รหัส `11450` ได้ชั่วคราว)
3. Authentication → Users → Add user: email `11450@swdcph.app`, password `11450`, ติ๊ก Auto Confirm → รันบรรทัด `insert into profiles ...` ท้ายไฟล์ schema.sql
4. Project Settings → API → คัดลอก **anon / publishable key** ใส่ `SUPABASE_KEY` ใน `index.html` (ห้ามใช้ service_role)
5. GitHub → Settings → Pages → Deploy from branch `main` / root
6. กรอกกรอบอัตรากำลังในตาราง `framework`

เข้าสู่ระบบด้วยชื่อผู้ใช้ `11450` / รหัสผ่าน `11450` (ชั่วคราว — **ต้องเปลี่ยนก่อนใส่ข้อมูลจริง**)

## PDPA
ห้าม commit ไฟล์ข้อมูลบุคลากรจริงลง repo ข้อมูลอยู่ใน Supabase เท่านั้น และถูกป้องกันด้วย RLS ตามบทบาท/หน่วยงาน
