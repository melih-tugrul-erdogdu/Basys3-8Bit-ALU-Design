# VERILOG-BASYS3
(Work In Progress) 

8-Bit ALU Design on Basys 3 FPGA
This repository contains the source codes of the ING220 Digital Electronics course term project. The purpose of the project is to develop an Arithmetic and Logic Unit (ALU) with its own memory structure, running on the Basys 3 board using the Verilog hardware description language.
🛠 Hardware Features


Word Length: 1 Byte (8-bit) data processing capability.


RAM: Internal memory with 256 blocks (1 Byte addressing).


Registers: 16 fast-access 8-bit registers.


Input Unit: 16-bit hardware instruction input (Basys 3 switches).


Output Unit: 3 seven-segment displays for result monitoring.


Clock Signal: Manual button (BTNC U18) for step-by-step control.


🗂 Module Structure
The system architecture consists of 3 main Verilog modules:


control_unit.v: Instruction decoder that parses the 16-bit switch input.


alu.v: Execution unit that performs 16 different arithmetic/logic operations (ADD, SUB, SHL, CMP, etc.).


testbench.v: Top-level test module that provides module integration and seven-segment display driving.



8-Bit ALU Design on Basys 3 FPGA
Bu depo, ING220 Sayısal Elektronik dersi dönem projesi kaynak kodlarını içermektedir. Projenin amacı, Verilog donanım tanımlama dili kullanılarak Basys 3 kartı üzerinde çalışan, kendi bellek yapısına sahip bir Aritmetik ve Mantık Ünitesi (ALU) geliştirmektir.
🛠 Donanım Özellikleri


Kelime Uzunluğu: 1 Bayt (8-bit) veri işleme kapasitesi.


RAM: 256 Blokluk (1 Bayt adresleme) dahili bellek.


Yazmaçlar (Registers): 16 Adet 8-bitlik hızlı erişim yazmacı.


Giriş Birimi: 16-bitlik donanımsal komut girişi (Basys 3 Switchleri).


Çıkış Birimi: Sonuç takibi için 3 adet 7-Segment Display.


Saat Sinyali (Clock): Adım adım kontrol için Manuel Buton (BTNC U18).


🗂 Modül Yapısı
Sistem mimarisi 3 ana Verilog modülünden oluşmaktadır:


control_unit.v: 16-bitlik anahtar girişini ayrıştıran komut çözücü (Instruction Decoder).


alu.v: 16 farklı aritmetik/lojik operasyonu (ADD, SUB, SHL, CMP vb.) gerçekleştiren yürütme birimi.


testbench.v: Modüllerin entegrasyonunu ve 7-segment ekran sürüşünü sağlayan üst düzey test modülü.


