module bintobcd(
  input [19:0] valor_bin,
  output reg [23:0] valor_bcd
);

integer i;

always @(valor_bin) begin
    valor_bcd = 0;
    for (i = 0; i < 20; i = i + 1) begin
        if (valor_bcd[3:0] >= 5) begin
            valor_bcd[3:0] = valor_bcd[3:0] + 3;
        end
        if (valor_bcd[7:4] >= 5) begin
            valor_bcd[7:4] = valor_bcd[7:4] + 3;
        end
        if (valor_bcd[11:8] >= 5) begin
            valor_bcd[11:8] = valor_bcd[11:8] + 3;
        end
        if (valor_bcd[15:12] >= 5) begin
            valor_bcd[15:12] = valor_bcd[15:12] + 3;
        end
        if (valor_bcd[19:16] >= 5) begin
            valor_bcd[19:16] = valor_bcd[19:16] + 3;
        end
        if (valor_bcd[23:20] >= 5) begin
            valor_bcd[23:20] = valor_bcd[23:20] + 3;
        end
        valor_bcd = {valor_bcd[22:0], valor_bin[19-i]};
    end
end

endmodule