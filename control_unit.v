`timescale 1ns / 1ps

//Son Bir İpucu: Kodları .v dosyalarınıza attıktan sonra Vivado'da "Constraints" klasörü altına Basys3 Master XDC dosyasını eklemeyi ve kullandığımız pinlerin (clk, sw, btnC, an, seg, led) yorum satırı işaretlerini (#) kaldırmayı unutmayın.

// control_unit.v
// Gelen 16-bitlik anahtar girişini (instruction) analiz edip,
// ALU'nun anlayabileceği alt sinyallere (opcode, adresler, veri) böler.

module control_unit(
    input [15:0] instruction,
    output reg [3:0] opcode,
    output reg [3:0] rd_addr, // Hedef yazmaç (Destination)
    output reg [3:0] ra_addr, // 1. Kaynak yazmaç (Source A)
    output reg [3:0] rb_addr, // 2. Kaynak yazmaç (Source B)
    output reg [7:0] mem_addr, // RAM adresi
    output reg [7:0] omega     // Doğrudan atama verisi
);

    always @(*) begin
        // Opcode her zaman en anlamlı 4 bittir
        opcode = instruction[15:12];

        // İstenmeyen mandal (latch) oluşumunu engellemek için varsayılan atamalar
        rd_addr  = 4'b0000;
        ra_addr  = 4'b0000;
        rb_addr  = 4'b0000;
        mem_addr = 8'b0000_0000;
        omega    = 8'b0000_0000;

        // İşlem tipine (Komut Setine) göre 12 bitlik kısmı parçalıyoruz
        case(opcode)
            4'b0000: begin // LOA: W değerini Rd'ye yükle
                rd_addr = instruction[11:8];
                omega   = instruction[7:0];
            end
            4'b0001: begin // REA: RAM'den Rd'ye oku
                rd_addr  = instruction[11:8];
                mem_addr = instruction[7:0];
            end
            4'b0010: begin // STR: Ra'daki veriyi RAM'e yaz
                ra_addr  = instruction[11:8];
                mem_addr = instruction[7:0];
            end
            4'b0011: begin // MOV: Ra'yı Rd'ye taşı
                ra_addr = instruction[11:8];
                rd_addr = instruction[7:4];
                // Kalan 4 bit kullanılmaz.
            end
            4'b1110: begin // CMP: Karşılaştırma, sadece kaynak yazmaçlar okunur
                ra_addr = instruction[11:8];
                rb_addr = instruction[7:4];
            end
            default: begin // ADD, SUB, AND, XOR vb. standart ALU işlemleri
                ra_addr = instruction[11:8];
                rb_addr = instruction[7:4];
                rd_addr = instruction[3:0];
            end
        endcase
    end

endmodule
