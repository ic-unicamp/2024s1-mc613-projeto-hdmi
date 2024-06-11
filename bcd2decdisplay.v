module bcd2decdisplay(
  input [23:0] valor,
  output reg [6:0] digito0, // _ _ _ _ _ D
  output reg [6:0] digito1, // _ _ _ _ D _
  output reg [6:0] digito2, // _ _ _ D _ _
  output reg [6:0] digito3, // _ _ D _ _ _
  output reg [6:0] digito4, // _ D _ _ _ _
  output reg [6:0] digito5  // D _ _ _ _ _
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
        default: digito0 = 7'b1101111; // valor inválido
    endcase
     case(valor[7:4])
        4'b0000: digito1 = 7'b1000000; // 0
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
        4'b0000: digito2 = 7'b1000000; // 0
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
        case(valor[15:12])
        4'b0000: digito3 = 7'b1000000; // 0
        4'b0001: digito3 = 7'b1111001; // 1
        4'b0010: digito3 = 7'b0100100; // 2
        4'b0011: digito3 = 7'b0110000; // 3
        4'b0100: digito3 = 7'b0011001; // 4
        4'b0101: digito3 = 7'b0010010; // 5
        4'b0110: digito3 = 7'b0000010; // 6
        4'b0111: digito3 = 7'b1111000; // 7
        4'b1000: digito3 = 7'b0000000; // 8
        4'b1001: digito3 = 7'b0011000; // 9
        default: digito3 = 7'b1111111; // valor inválido
  endcase
      case(valor[19:16])
        4'b0000: digito4 = 7'b1000000; // 0
        4'b0001: digito4 = 7'b1111001; // 1
        4'b0010: digito4 = 7'b0100100; // 2
        4'b0011: digito4 = 7'b0110000; // 3
        4'b0100: digito4 = 7'b0011001; // 4
        4'b0101: digito4 = 7'b0010010; // 5
        4'b0110: digito4 = 7'b0000010; // 6
        4'b0111: digito4 = 7'b1111000; // 7
        4'b1000: digito4 = 7'b0000000; // 8
        4'b1001: digito4 = 7'b0011000; // 9
        default: digito4 = 7'b1111111; // valor inválido
  endcase
      case(valor[23:20])
        4'b0000: digito5 = 7'b1000000; // 0
        4'b0001: digito5 = 7'b1111001; // 1
        4'b0010: digito5 = 7'b0100100; // 2
        4'b0011: digito5 = 7'b0110000; // 3
        4'b0100: digito5 = 7'b0011001; // 4
        4'b0101: digito5 = 7'b0010010; // 5
        4'b0110: digito5 = 7'b0000010; // 6
        4'b0111: digito5 = 7'b1111000; // 7
        4'b1000: digito5 = 7'b0000000; // 8
        4'b1001: digito5 = 7'b0011000; // 9
        default: digito5 = 7'b1111111; // valor inválido
  endcase
end

endmodule