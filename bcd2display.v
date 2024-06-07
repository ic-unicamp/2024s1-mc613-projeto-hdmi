module bcd2display(
  input [11:0] valor,
  output reg [6:0] digito0, // _ _ _ _ _ D
  output reg [6:0] digito1, // _ _ _ _ D _
  output reg [6:0] digito2  // _ _ _ D _ _
);

// Não usar posedge e negedge, quando o somar sobe ou desce, fazer a operação 1 vez

always @(valor) 
begin
    case(valor[3:0])
        4'b0000: digito0 = 7'b1000000; // 0
        4'b0001: digito0 = 7'b1111001; // 1
        4'b0010: digito0 = 7'b0100100; // 2
        4'b0011: digito0 = 7'b0110000; // 3
        4'b0100: digito0 = 7'b0011001; // 4
        4'b0101: digito0 = 7'b0010010; // 5
        4'b0110: digito0 = 7'b0000010; // 6
        4'b0111: digito0 = 7'b1111000; // 7
        4'b1000: digito0 = 7'b0000000; // 8
        4'b1001: digito0 = 7'b0011000; // 9
        default: digito0 = 7'b1111111; // valor inválido
    endcase
    case(valor[7:4])
        4'b0000: digito1 = 7'b1111111; // 0
        4'b0001: digito1 = 7'b1111001; // 1
        4'b0010: digito1 = 7'b0100100; // 2
        4'b0011: digito1 = 7'b0110000; // 3
        4'b0100: digito1 = 7'b0011001; // 4
        4'b0101: digito1 = 7'b0010010; // 5
        4'b0110: digito1 = 7'b0000010; // 6
        4'b0111: digito1 = 7'b1111000; // 7
        4'b1000: digito1 = 7'b0000000; // 8
        4'b1001: digito1 = 7'b0011000; // 9
        default: digito1 = 7'b1111111; // valor inválido
    endcase
    case(valor[11:8])
        4'b0000: digito2 = 7'b1111111; // 0
        4'b0001: digito2 = 7'b1111001; // 1
        4'b0010: digito2 = 7'b0100100; // 2
        4'b0011: digito2 = 7'b0110000; // 3
        4'b0100: digito2 = 7'b0011001; // 4
        4'b0101: digito2 = 7'b0010010; // 5
        4'b0110: digito2 = 7'b0000010; // 6
        4'b0111: digito2 = 7'b1111000; // 7
        4'b1000: digito2 = 7'b0000000; // 8
        4'b1001: digito2 = 7'b0011000; // 9
        default: digito2 = 7'b1111111; // valor inválido
    endcase
end

endmodule