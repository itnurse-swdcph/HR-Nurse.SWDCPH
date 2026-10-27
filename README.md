# HR Nurse SWDCPH
ระบบบันทึกเข้า-ออกบุคลากรทางการพยาบาล + แดชบอร์ดผู้บริหาร (กลุ่มการพยาบาล รพ.สมเด็จพระยุพราชสว่างแดนดิน)

**สถาปัตยกรรม:** `index.html` (GitHub Pages) → Google Apps Script (`backend/Code.gs`) → Google Sheet (ฐานข้อมูล)

## ติดตั้ง
1. สร้าง Google Sheet ใหม่ (เป็น **private**) → ส่วนขยาย → Apps Script → วาง `backend/Code.gs`
2. รันฟังก์ชัน `setup()` หนึ่งครั้ง (สร้างชีต Personnel, Events, Framework, Users และผู้ใช้ `admin` / `changeme` **เปลี่ยนรหัสทันที**)
3. Deploy → Web app → Execute as: Me, Access: Anyone → คัดลอก URL ไปใส่ `API_URL` ใน `index.html`
4. GitHub → Settings → Pages → Deploy from branch `main` / root
5. กรอกกรอบอัตรากำลังในชีต `Framework` (unit, position, quota)

## หมายเหตุด้านข้อมูล (PDPA)
- **ห้าม commit ข้อมูลบุคลากรจริง (ไฟล์ .xlsx) ลง repo** ข้อมูลอยู่ใน Google Sheet เท่านั้น
- เพิ่มผู้ใช้ในชีต `Users`: `pass_hash` = SHA-256 ของรหัสผ่าน, role = admin | unit_head | viewer, unit = ชื่อหน่วย หรือ `*` (ทุกหน่วย)
