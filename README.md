### (WORK IN PROGRESS)


# 8-Bit ALU Design on Basys 3 FPGA

## Project Overview
This project involves the design and implementation of an 8-bit Arithmetic Logic Unit (ALU) using Verilog on the Basys 3 FPGA. The system incorporates internal RAM, a register file, and a custom instruction set to perform various arithmetic, logic, and memory operations.

## Hardware Specifications
- **Word Length:** 1 Byte (8-bit).
- **Memory (RAM):** 256 bytes ($2^8 = 256$) with 8-bit addressing.
- **Registers (R):** 16 8-bit registers ($2^4 = 16$) with 4-bit addressing.
- **Inputs:** 16 physical switches on Basys 3 (4-bit Opcode + 12-bit Address/Data).
- **Clock:** Manual clock trigger using BTNC (U18) for step-by-step execution.
- **Outputs:** Results are displayed on three 7-segment displays.

## Instruction Set
The ALU supports 16 operations (4-bit Opcodes):
- **Memory:** LOA (Load), REA (Read RAM), STR (Store RAM), MOV (Move).
- **Arithmetic:** ADD (Addition), SUB (Subtraction), INC (Increment), DEC (Decrement).
- **Logic:** AND, ORX (OR), XOR, NOT.
- **Shifts:** SHL (Shift Left), SHR (Shift Right).
- **Control:** CMP (Compare with flags B/E/K), NEX (No Operation).

## Project Architecture
The design is modularized into three primary Verilog components:
1. `control_unit.v`: Decodes the 16-bit input and manages address/data routing.
2. `alu.v`: Executes the specified operation and interacts with RAM/Registers.
3. `testbench.v`: Integrates the modules and handles the 7-segment display logic.

---

# Basys 3 FPGA Üzerinde 8-Bit ALU Tasarımı

## Proje Özeti
Bu proje, Basys 3 FPGA üzerinde Verilog kullanılarak 8-bitlik bir Aritmetik Mantık Birimi (ALU) tasarımını ve uygulamasını içermektedir. Sistem; aritmetik, mantık ve bellek işlemlerini gerçekleştirmek için dahili RAM, yazmaç dosyası ve özel bir komut seti kullanmaktadır.

## Teknik Özellikler
- **Kelime Uzunluğu:** 1 Bayt (8-bit).
- **Bellek (RAM):** 8-bit adreslemeli 256 bayt ($2^8 = 256$).
- **Yazmaçlar (R):** 4-bit adreslemeli 16 adet 8-bit yazmaç ($2^4 = 16$).
- **Girişler:** Basys 3 üzerindeki 16 fiziksel anahtar (4-bit İşlem Kodu + 12-bit Adres/Veri).
- **Saat (Clock):** Adım adım ilerleme için BTNC (U18) orta butonu ile manuel tetikleme.
- **Çıkışlar:** İşlem sonuçları kart üzerindeki üç adet 7-segment gösterge üzerinde görüntülenir.

## Komut Seti
ALU, 16 farklı işlemi (4-bit Opcode) destekler:
- **Bellek:** LOA (Yükle), REA (RAM Oku), STR (RAM Yaz), MOV (Taşı).
- **Aritmetik:** ADD (Toplama), SUB (Çıkarma), INC (Artır), DEC (Azalt).
- **Mantık:** AND (VE), ORX (VEYA), XOR (ÖZEL VEYA), NOT (DEĞİL).
- **Kaydırma:** SHL (Sola Kaydır), SHR (Sağa Kaydır).
- **Kontrol:** CMP (Karşılaştır - B/E/K bayrakları), NEX (İşlem Yapma).

## Proje Mimarisi
Tasarım, hiyerarşik olarak üç ana Verilog modülüne ayrılmıştır:
1. `control_unit.v`: 16-bitlik girişi çözer, adres ve veri yönlendirmesini yönetir.
2. `alu.v`: Belirlenen işlemi yürütür; RAM ve yazmaçlar ile etkileşime girer.
3. `testbench.v`: Modülleri entegre eder ve 7-segment ekran sürme mantığını yönetir.
