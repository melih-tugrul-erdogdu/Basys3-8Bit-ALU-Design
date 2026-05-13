`timescale 1ns / 1ps

//Son Bir İpucu: Kodları .v dosyalarınıza attıktan sonra Vivado'da "Constraints" klasörü altına Basys3 Master XDC dosyasını eklemeyi ve kullandığımız pinlerin (clk, sw, btnC, an, seg, led) yorum satırı işaretlerini (#) kaldırmayı unutmayın.

// alu.v
// Bellekleri barındıran ve asıl matematiksel/lojik işlemleri yapan beyin.

module alu(
    input clk, // İşlemi tetikleyecek saat vuruşu (BTNC'den gelecek)
    input [3:0] opcode,
    input [3:0] rd_addr,
    input [3:0] ra_addr,
    input [3:0] rb_addr,
    input [7:0] mem_addr,
    input [7:0] omega,
    output reg [7:0] out_data, // Ekranda göstermek için son işlemin sonucu
    output reg flag_B,         // Ra > Rb bayrağı
    output reg flag_E,         // Ra == Rb bayrağı
    output reg flag_K          // Ra < Rb bayrağı
);

    // Donanımsal Bellek Tanımlamaları
    reg [7:0] RAM [0:255]; // 256 adet 8-bitlik RAM bloğu
    reg [7:0] R [0:15];    // 16 adet 8-bitlik Yazmaç (Register) bloğu

    // Devre ilk açıldığında belleklerin temiz olması için başlangıç değerleri
    integer i;
    initial begin
        for(i=0; i<256; i=i+1) RAM[i] = 8'd0;
        for(i=0; i<16; i=i+1) R[i] = 8'd0;
        out_data = 8'd0;
        flag_B = 0; flag_E = 0; flag_K = 0;
    end

    // Senkron İşlem: Sadece butona basıldığında (posedge) işlemi gerçekleştir
    always @(posedge clk) begin
        case(opcode)
            4'b0000: begin // LOA
                R[rd_addr] <= omega;
                out_data <= omega;
            end
            4'b0001: begin // REA
                R[rd_addr] <= RAM[mem_addr];
                out_data <= RAM[mem_addr];
            end
            4'b0010: begin // STR
                RAM[mem_addr] <= R[ra_addr];
                out_data <= R[ra_addr]; // Kaydedilen veriyi ekranda teyit edelim
            end
            4'b0011: begin // MOV
                R[rd_addr] <= R[ra_addr];
                out_data <= R[ra_addr];
            end
            4'b0100: begin // ADD
                R[rd_addr] <= R[ra_addr] + R[rb_addr];
                out_data <= R[ra_addr] + R[rb_addr];
            end
            4'b0101: begin // SUB
                R[rd_addr] <= R[ra_addr] - R[rb_addr];
                out_data <= R[ra_addr] - R[rb_addr];
            end
            4'b0110: begin // INC
                R[rd_addr] <= R[ra_addr] + 1;
                out_data <= R[ra_addr] + 1;
            end
            4'b0111: begin // DEC
                R[rd_addr] <= R[ra_addr] - 1;
                out_data <= R[ra_addr] - 1;
            end
            4'b1000: begin // AND
                R[rd_addr] <= R[ra_addr] & R[rb_addr];
                out_data <= R[ra_addr] & R[rb_addr];
            end
            4'b1001: begin // ORX
                R[rd_addr] <= R[ra_addr] | R[rb_addr];
                out_data <= R[ra_addr] | R[rb_addr];
            end
            4'b1010: begin // XOR
                R[rd_addr] <= R[ra_addr] ^ R[rb_addr];
                out_data <= R[ra_addr] ^ R[rb_addr];
            end
            4'b1011: begin // NOT
                R[rd_addr] <= ~R[ra_addr];
                out_data <= ~R[ra_addr];
            end
            4'b1100: begin // SHL
                R[rd_addr] <= R[ra_addr] << 1;
                out_data <= R[ra_addr] << 1;
            end
            4'b1101: begin // SHR
                R[rd_addr] <= R[ra_addr] >> 1;
                out_data <= R[ra_addr] >> 1;
            end
            4'b1110: begin // CMP (Yazmaca yazmaz, sadece bayrakları (flag) günceller)
                if (R[ra_addr] > R[rb_addr]) begin
                    flag_B <= 1; flag_E <= 0; flag_K <= 0;
                end else if (R[ra_addr] == R[rb_addr]) begin
                    flag_B <= 0; flag_E <= 1; flag_K <= 0;
                end else begin
                    flag_B <= 0; flag_E <= 0; flag_K <= 1;
                end
            end
            4'b1111: begin // NEX
                // Hiçbir şey yapma (No-Operation)
            end
        endcase
    end

endmodule
