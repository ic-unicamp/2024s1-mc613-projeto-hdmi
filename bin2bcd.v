module bin2bcd(
  input [9:0] valor_bin,
  output reg [11:0] valor_bcd
);

integer i;

always @(valor_bin) begin
    valor_bcd = 0;
    for (i = 0; i < 7; i = i + 1) begin
        if (valor_bcd[3:0] >= 5) begin
            valor_bcd[3:0] = valor_bcd[3:0] + 3;
        end
        if (valor_bcd[7:4] >= 5) begin
            valor_bcd[7:4] = valor_bcd[7:4] + 3;
        end
        if (valor_bcd[11:8] >= 5) begin
            valor_bcd[11:8] = valor_bcd[11:8] + 3;
        end
        valor_bcd = {valor_bcd[10:0], valor_bin[9-i]};
    end
end

endmodule