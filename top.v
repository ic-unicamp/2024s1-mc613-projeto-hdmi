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
	output VGA_SYNC_N
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

wire [9:0] player_x, player_y;

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

wire obstacle_x;
wire obstacle_y;
reg [2:0] obstacle_step_x;
reg [2:0] obstacle_step_y;
reg [9:0] obstacle_start_x;
reg [9:0] obstacle_spawn_timer;
reg [1:0] obstacle_trigger;
reg game_over;

controllerObstacle controllerObstacle(
  .CLOCK_50(CLOCK_50),
  .reset(reset),
  .obstacle_trigger(obstacle_trigger),
  .obstacle_start_x(obstacle_start_x),
  .obstacle_x(obstacle_x),
  .obstacle_y(obstacle_y)
);

reg [6:0] max_score = 0;
reg [6:0] score = 0;

reg [6:0] spawn_position_index = 0;
reg [9:0] spawn_position_list [0:99];
spawn_position_list[0:99] = '{
	305, 419, 548, 474, 247,  42, 189, 307, 567, 433,
	116, 510,  32, 535, 181,   5, 260, 201, 532, 249,
	333, 217, 376, 130,  35, 115, 583,  90, 243, 205,
	429, 515,  88, 556, 348, 371, 298, 602, 386, 328,
	203, 364, 270, 507, 366,  56,  83, 523, 476,  71,
	324, 494, 480, 225, 579, 365,   7, 502, 394, 447,
	346,  26, 289,  37, 513, 207,   8,   9,  68, 398,
	104, 530,  52, 606, 136, 188, 357, 131, 399, 540,
	 51,  60, 214, 396, 226, 316, 254, 251, 134, 318,
	237, 206,  48, 180, 241, 110, 144, 482, 145, 551};

always @(posedge SLOW_CLK) begin

  // Reset (DEVE ESTAR ZUADO)
  if (reset) begin
	game_over = 1;
	score = 0;
	max_score = 0;
	divider = 500000;

  end else begin	

    // Game
	if(~game_over) begin
		
		// spawn_position_index = spawn_position_index + 1;
		// if (spawn_position_index >= 100) begin
		// 	spawn_position_index = spawn_position_index - 100;
		// end

		// FAZER O spawn_position_list[spawn_position_index] SER O SPAWN DO OBSTÁCULO
        // obstacle_start_x = spawn_position_list[spawn_position_index];

		obstacle_start_x = 100;

		obstacle_spawn_timer = obstacle_spawn_timer + 1;
		if (obstacle_spawn_timer >= obstacle_spawn_delay) begin
			obstacle_trigger = 1;
			obstacle_spawn_timer = 0;
		end else begin
			obstacle_trigger = 0;
		end

	 end
  end

end

always @ (posedge CLOCK_50) begin
	red = ((obstacle_drawing && obstacle_color) || (player_drawing && player_color)) ? 255 : 0;
	blue = ((obstacle_drawing && obstacle_color) || (player_drawing && player_color)) ? 255 : 0;
	green = ((obstacle_drawing && obstacle_color) || (player_drawing && player_color)) ? 255 : 0;
end

endmodule