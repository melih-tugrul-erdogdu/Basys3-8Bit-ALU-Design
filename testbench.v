`timescale 1ns / 1ps

//Son Bir İpucu: Kodları .v dosyalarınıza attıktan sonra Vivado'da "Constraints" klasörü altına Basys3 Master XDC dosyasını eklemeyi ve kullandığımız pinlerin (clk, sw, btnC, an, seg, led) yorum satırı işaretlerini (#) kaldırmayı unutmayın.

// testbench.v (Top Modül)
// Basys 3 FPGA üzerine sentezlenecek ana modüldür. Alt modülleri çağırır, 
// birbirine bağlar ve 7-segment ekranı tarama (multiplexing) ile yönetir.

module testbench(
    input clk,          // Basys3'ün kendi 100MHz sistem saati (W5 pini - Ekran taraması için)
    input btnC,         // İşlemi manuel tetikleyecek buton (ALU saati - U18 pini)
    input [15:0] sw,    // 16 adet giriş anahtarı (Switch)
    output [3:0] an,    // 7-segment anotları
    output [6:0] seg,   // 7-segment katotları (a,b,c,d,e,f,g)
    output [2:0] led    // Karşılaştırma bayraklarını (CMP) göstermek için ilk 3 LED
);

    // Modüller Arası Kablolar (Internal Wires)
    wire [3:0] op;
    wire [3:0] rd, ra, rb;
    wire [7:0] addr, omega, alu_out;
    wire b_flag, e_flag, k_flag;

    // CMP işlemini test ederken sonucu rahatça görmek için LED ataması
    assign led[0] = b_flag;
    assign led[1] = e_flag;
    assign led[2] = k_flag;

    // 1. Kontrol Birimini (Beyni) Sisteme Ekle
    control_unit cu_inst (
        .instruction(sw),
        .opcode(op),
        .rd_addr(rd),
        .ra_addr(ra),
        .rb_addr(rb),
        .mem_addr(addr),
        .omega(omega)
    );

    // 2. ALU'yu Sisteme Ekle
    alu alu_inst (
        .clk(btnC), // Hoca işlemleri manuel butonla test edeceğinizi belirtmişti
        .opcode(op),
        .rd_addr(rd),
        .ra_addr(ra),
        .rb_addr(rb),
        .mem_addr(addr),
        .omega(omega),
        .out_data(alu_out),
        .flag_B(b_flag),
        .flag_E(e_flag),
        .flag_K(k_flag)
    );

    // 3. 7-Segment Ekran Sürücüsü (Multiplexing)
    reg [19:0] refresh_counter; // 100MHz'i gözün görebileceği hıza yavaşlatmak için sayaç
    wire [1:0] led_activating_counter;

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    assign led_activating_counter = refresh_counter[19:18];

    reg [3:0] active_digit;
    reg [3:0] anode_temp;

    always @(*) begin
        case(led_activating_counter)
            2'b00: begin
                anode_temp = 4'b0111; // 1. hane (En Sol) aktif -> Opcode'u gösterir
                active_digit = op;
            end
            2'b01: begin
                anode_temp = 4'b1111; // 2. hane KAPALI (Hoca "3 adet kullanacaksınız" dediği için bunu söndürüp boşluk yaratıyoruz)
                active_digit = 4'h0;
            end
            2'b10: begin
                anode_temp = 4'b1101; // 3. hane aktif -> Sonuç Verisi (Üst 4-bit)
                active_digit = alu_out[7:4];
            end
            2'b11: begin
                anode_temp = 4'b1110; // 4. hane (En Sağ) aktif -> Sonuç Verisi (Alt 4-bit)
                active_digit = alu_out[3:0];
            end
        endcase
    end

    assign an = anode_temp;

    // 7-segment BCD'den HEX'e Çözücü
    reg [6:0] seg_temp;
    always @(*) begin
        case(active_digit)
            4'h0: seg_temp = 7'b1000000;
            4'h1: seg_temp = 7'b1111001;
            4'h2: seg_temp = 7'b0100100;
            4'h3: seg_temp = 7'b0110000;
            4'h4: seg_temp = 7'b0011001;
            4'h5: seg_temp = 7'b0010010;
            4'h6: seg_temp = 7'b0000010;
            4'h7: seg_temp = 7'b1111000;
            4'h8: seg_temp = 7'b0000000;
            4'h9: seg_temp = 7'b0010000;
            4'hA: seg_temp = 7'b0001000;
            4'hB: seg_temp = 7'b0000011;
            4'hC: seg_temp = 7'b1000110;
            4'hD: seg_temp = 7'b0100001;
            4'hE: seg_temp = 7'b0000110;
            4'hF: seg_temp = 7'b0001110;
            default: seg_temp = 7'b1111111;
        endcase
    end
    
    // Basys 3'te segmentler Active-Low çalışır.
    // Ancak 2. hane boş kalsın diye anodu (1111) kapattığımızdan o sırada segmentlerin yanması sorun yaratmaz.
    assign seg = seg_temp;

endmodule
