# Asuna

ช่วยเขียนเทสใน **Claude Code** ให้โปรเจกต์ที่ใช้ Playwright หรือ Vitest

อ่านโค้ดกับเทสที่มีอยู่แล้ว แล้วเขียนตามสไตล์นั้น ไม่เดา ไม่สร้าง framework ใหม่

ไม่ต้องมี `.cursor/` — ค่าเริ่มต้นติดตั้งเฉพาะ Claude Code

## ติดตั้ง

เปิดเทอร์มินัล **ในโฟลเดอร์โปรเจกต์** แล้ววางคำสั่งนี้:

```bash
curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash
```

เสร็จแล้ว commit โฟลเดอร์ `.claude/` เพื่อให้คนในทีมได้ใช้ด้วย

**อยากใช้ทุกโปรเจกต์บนเครื่องนี้** ไม่ต้องติดตั้งทีละอัน:

```bash
curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash -s -- --global
```

## ใช้ยังไง

1. เปิดแชทใหม่ใน Claude Code
2. พิมพ์ `@asuna` แล้วบอกว่าอยากได้อะไร

```
@asuna เพิ่ม test หน้า login
@asuna วางแผนเคสจากลิสต์นี้
@asuna ทำไมเทสนี้ fail
@asuna รันเทสไฟล์นี้ให้หน่อย
@asuna ตรวจว่าเทสที่เพิ่งเขียนถูก convention ไหม
```

| อยากได้ | พิมพ์ประมาณนี้ |
|--------|----------------|
| เขียน / แก้เทส | `@asuna เพิ่ม test …` |
| วางแผนก่อนลงมือ | `@asuna plan coverage …` |
| เทสแดง / flaky | `@asuna ทำไมเคสนี้ fail` |
| รันเทส | `@asuna รันเทส` |
| ตรวจ PR / diff | `@asuna ตรวจเทสนี้` |

ใช้ได้ทั้งภาษาไทยและอังกฤษ

## สิ่งที่ Asuna จะทำ

- ดูว่าโปรเจกต์เป็น Playwright, Vitest หรือทั้งสอง
- อ่านหน้าจอ / ฟังก์ชันจริงก่อนเขียนเทส
- เขียนให้เหมือนไฟล์เทสข้าง ๆ
- รันเทสให้ แล้วบอกผลตามที่รันจริง

ถ้าในโค้ดหาคำตอบไม่เจอ Asuna จะถาม ไม่เดา

## ตัวเลือกเพิ่มเติม

ใช้ Cursor ด้วย (จะได้โฟลเดอร์ `.cursor/` เพิ่ม):

```bash
curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash -s -- --cursor
```

ทับไฟล์เดิม:

```bash
curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash -s -- --force
```

โปรเจกต์ยังไม่มี Playwright อยากได้โครง POM พร้อมใช้:

```bash
curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash -s -- --templates
```

มี clone อยู่แล้ว:

```bash
./install.sh .
./install.sh --global
```
