module vga(
  input reset,
  input CLOCK_50,
  input [7:0] red,
  input [7:0] green,
  input [7:0] blue,
  output reg VGA_CLK,
  output VGA_HS,
  output VGA_VS,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_BLANK_N,
  output VGA_SYNC_N,
  output [9:0] next_x,
  output [9:0] next_y,
  output line
  // inclua os demais sinais aqui
);

reg [9:0] x;
reg [9:0] y;
wire ativo;

// Divisor de frequência para gerar o clock da VGA
always @(posedge CLOCK_50) begin
  if (reset) begin
    VGA_CLK = 1'b0;
  end else begin
    VGA_CLK = ~VGA_CLK;
  end
end

always @(posedge VGA_CLK) begin
  if (reset) begin
    x = 0;
    y = 0;
  end else begin
    x = x + 1;
    if (x == 800) begin
      x = 0;
      y = y + 1;
      if (y == 525) begin // verificar limite
        y = 0;
      end
    end
  end  
end

assign VGA_HS = (x < 96) ? 0 : 1; // verificar limite
assign VGA_VS = (y < 2) ? 0 : 1; // verificar limite
assign VGA_BLANK_N = VGA_HS & VGA_VS; // tente com 1 constante
assign VGA_SYNC_N = 1;
assign ativo = (x >= 96) & (y >= 2);
assign VGA_R = ativo ? red : 8'b00000000;
assign VGA_G = ativo ? green : 8'b00000000;
assign VGA_B = ativo ? blue : 8'b00000000;
assign line = (x == 96+45);

assign next_x = x - (96+40); // offset retirado em calibracao na tela
assign next_y = y - (2+33); // offset retirado em calibracao na tela

endmodule