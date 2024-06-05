module top(
	input CLOCK_50,
	input [9:0] SW,
	input [3:0] KEY,
	output VGA_CLK,
	output VGA_HS,
	output VGA_VS,
	output [7:0] VGA_R,
	output [7:0] VGA_G,
	output [7:0] VGA_B,
	output VGA_BLANK_N,
	output VGA_SYNC_N,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2
);

wire [9:0] next_x;
wire [9:0] next_y;
wire reset = SW[0];
wire left_button = KEY[1];
wire right_button = KEY[0];

// Variáveis para o clock
reg [31:0] counter = 0;
reg [31:0] divider = 500000;  // Modifique para dividir a barra por um valor maior
reg SLOW_CLK;
wire [9:0] player_x;
wire [9:0] player_y;

// Divisor de frequência para gerar o clock da VGA e o clock da velocidade do jogo
always @(posedge CLOCK_50) begin
    counter = counter + 1;
    if (counter == divider) begin
      SLOW_CLK = ~SLOW_CLK;
      counter = 0;
    end
end

vga vga(
    .reset(reset),
    .CLOCK_50(CLOCK_50),
    .red(red),
    .green(green),
    .blue(blue),
    .VGA_CLK(VGA_CLK),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_BLANK_N(VGA_BLANK_N),
    .VGA_SYNC_N(VGA_SYNC_N),
    .next_x(next_x),
    .next_y(next_y)
);

 spriteObjeto3 spriteObjeto3(
 	.clk(CLOCK_50),
 	.reset(reset),
 	.x(next_x), 
 	.y(next_y), 
 	.vsync(VGA_VS),
 	.sprite_x(obstacle_x), 
 	.sprite_y(obstacle_y),
 	.color(obstacle_color),
 	.drawing(obstacle_drawing)
 );

 spriteNave spriteNave(
 	.clk(CLOCK_50),
 	.reset(reset),
 	.x(next_x), 
 	.y(next_y), 
 	.vsync(VGA_VS),
 	.sprite_x(player_x), 
 	.sprite_y(player_y),
 	.color(player_color),
 	.drawing(player_drawing)
 );

controllerPlayer controllerPlayer(
  .CLOCK_50(CLOCK_50),
  .reset(reset),
  .left_button(left_button),
  .right_button(right_button),
  .player_x(player_x),
  .player_y(player_y)
);

reg [7:0] red;
reg [7:0] green;
reg [7:0] blue;

// Obstacle parameters
parameter [9:0] obstacle_size_x = 32;
parameter [9:0] obstacle_size_y = 32;
parameter [9:0] obstacle_spawn_delay = 10000;

wire [9:0] obstacle_x;
wire [9:0] obstacle_y;
reg [2:0] obstacle_step_x;
reg [2:0] obstacle_step_y;
reg [9:0] obstacle_spawn_timer;
reg [1:0] obstacle_trigger;
reg game_over;

reg [9:0] obstacle_start_x;

controllerObstacle controllerObstacle(
  .clk(SLOW_CLK),
  .reset(reset),
  .obstacle_trigger(1),
  .obstacle_start_x(obstacle_start_x),  // O PROBLEMA FICA AQUI, SE SETAR O CALOR COM A VARIAVEL, N FUNCIONA
  .obstacle_x(obstacle_x),
  .obstacle_y(obstacle_y)
);

wire[11:0] valor_bcd;

bin2bcd bin2bcd(
	.valor_bin(obstacle_y),
	.valor_bcd(valor_bcd)
);

bcd2display bcd2display(
	.valor(valor_bcd),
	.digito0(HEX0),
	.digito1(HEX1),
	.digito2(HEX2)
);

reg [6:0] max_score = 0;
reg [6:0] score = 0;

reg [9:0] rngNumber;

always @(posedge SLOW_CLK) begin

  // Reset (DEVE ESTAR ZUADO)
  if (reset) begin
	game_over = 1;
	score = 0;
	max_score = 0;
	divider = 500000;

  end else begin
  
	 rngNumber = rngNumber + 1;
	 if (rngNumber > 607) begin
		rngNumber = 0;
	 end

	// DEFICINIR OBSTACLE_START_X RANDOM, O LUCCA C. TEM ISSO
	 obstacle_start_x = rngNumber;
	 
	 // MAS ESSA POSICAO ESTA DEFINDO O X DO OBSTACULO SEMPRE, TEM QUE SER SO O PONTO DE INICIO DELE

	// obstacle_spawn_timer = obstacle_spawn_timer + 1;
	// if (obstacle_spawn_timer >= obstacle_spawn_delay) begin
	// 	obstacle_trigger = 1;
	// 	obstacle_spawn_timer = 0;
	// end else begin
	// 	obstacle_trigger = 0;
	// end
	
  end

end

always @ (posedge CLOCK_50) begin
	red = ((obstacle_drawing && obstacle_color) || (player_drawing && player_color)) ? 255 : 0;
	blue = ((obstacle_drawing && obstacle_color) || (player_drawing && player_color)) ? 255 : 0;
	green = ((obstacle_drawing && obstacle_color) || (player_drawing && player_color)) ? 255 : 0;
end

endmodule