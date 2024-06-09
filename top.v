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
reg [31:0] divider = 750000;
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

 spriteObjeto3 spriteObstaculo0(
	.clk(CLOCK_50),
	.reset(reset),
	.x(next_x),
	.y(next_y),
	.vsync(VGA_VS),
	.sprite_x(obstacle0_x),
	.sprite_y(obstacle0_y),
	.color(obstacle0_color),
	.drawing(obstacle0_drawing)
 );
 
 spriteObjeto3 spriteObstaculo1(
	.clk(CLOCK_50),
	.reset(reset),
	.x(next_x),
	.y(next_y),
	.vsync(VGA_VS),
	.sprite_x(obstacle1_x),
	.sprite_y(obstacle1_y),
	.color(obstacle1_color),
	.drawing(obstacle1_drawing)
 );
 
 spriteObjeto3 spriteObstaculo2(
	.clk(CLOCK_50),
	.reset(reset),
	.x(next_x),
	.y(next_y),
	.vsync(VGA_VS),
	.sprite_x(obstacle2_x),
	.sprite_y(obstacle2_y),
	.color(obstacle2_color),
	.drawing(obstacle2_drawing)
 );
 
  spriteObjeto3 spriteObstaculo3(
	.clk(CLOCK_50),
	.reset(reset),
	.x(next_x),
	.y(next_y),
	.vsync(VGA_VS),
	.sprite_x(obstacle3_x),
	.sprite_y(obstacle3_y),
	.color(obstacle3_color),
	.drawing(obstacle3_drawing)
 );
 
  spriteObjeto3 spriteObstaculo4(
	.clk(CLOCK_50),
	.reset(reset),
	.x(next_x),
	.y(next_y),
	.vsync(VGA_VS),
	.sprite_x(obstacle4_x),
	.sprite_y(obstacle4_y),
	.color(obstacle4_color),
	.drawing(obstacle4_drawing)
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

// Player & Obstacle Parameters
parameter [9:0] player_size_x = 32;
parameter [9:0] player_size_y = 16;
parameter [9:0] obstacle_size_x = 32;
parameter [9:0] obstacle_size_y = 32;

reg [2:0] obstacle_step_x;
reg [2:0] obstacle_step_y;
reg [1:0] obstacle_trigger;
reg [1:0] game_over;

wire [9:0] obstacle0_x;
wire [9:0] obstacle1_x;
wire [9:0] obstacle2_x;
wire [9:0] obstacle3_x;
wire [9:0] obstacle4_x;
wire [9:0] obstacle0_y;
wire [9:0] obstacle1_y;
wire [9:0] obstacle2_y;
wire [9:0] obstacle3_y;
wire [9:0] obstacle4_y;

reg [9:0] obstacle0_start_x;
reg [9:0] obstacle1_start_x;
reg [9:0] obstacle2_start_x;
reg [9:0] obstacle3_start_x;
reg [9:0] obstacle4_start_x;
reg [9:0] obstacle0_start_y;
reg [9:0] obstacle1_start_y;
reg [9:0] obstacle2_start_y;
reg [9:0] obstacle3_start_y;
reg [9:0] obstacle4_start_y;

controllerObstacle controllerObstacle0(
	.clk(SLOW_CLK),
	.reset(reset),
	.obstacle_trigger(1),
	.obstacle_start_x(obstacle0_start_x),
	.obstacle_start_y(obstacle0_start_y),
	.obstacle_x(obstacle0_x),
	.obstacle_y(obstacle0_y)
);

controllerObstacle controllerObstacle1(
	.clk(SLOW_CLK),
	.reset(reset),
	.obstacle_trigger(1),
	.obstacle_start_x(obstacle1_start_x),
	.obstacle_start_y(obstacle1_start_y),
	.obstacle_x(obstacle1_x),
	.obstacle_y(obstacle1_y)
);

controllerObstacle controllerObstacle2(
	.clk(SLOW_CLK),
	.reset(reset),
	.obstacle_trigger(1),
	.obstacle_start_x(obstacle2_start_x),
	.obstacle_start_y(obstacle2_start_y),
	.obstacle_x(obstacle2_x),
	.obstacle_y(obstacle2_y)
);

controllerObstacle controllerObstacle3(
	.clk(SLOW_CLK),
	.reset(reset),
	.obstacle_trigger(1),
	.obstacle_start_x(obstacle3_start_x),
	.obstacle_start_y(obstacle3_start_y),
	.obstacle_x(obstacle3_x),
	.obstacle_y(obstacle3_y)
);

controllerObstacle controllerObstacle4(
	.clk(SLOW_CLK),
	.reset(reset),
	.obstacle_trigger(1),
	.obstacle_start_x(obstacle4_start_x),
	.obstacle_start_y(obstacle4_start_y),
	.obstacle_x(obstacle4_x),
	.obstacle_y(obstacle4_y)
);

wire[11:0] valor_bcd;

bin2bcd bin2bcd(
	.valor_bin(score),
	.valor_bcd(valor_bcd)
);

bcd2display bcd2display(
	.valor(valor_bcd),
	.digito0(HEX0),
	.digito1(HEX1),
	.digito2(HEX2)
);

reg [9:0] max_score = 0;
reg [9:0] score = 0;

reg [6:0] spawn_position_index = 0;
reg [9:0] spawn_position_list [0:99];

initial begin
	spawn_position_list[0] = 10'd116;
	spawn_position_list[1] = 10'd510;
	spawn_position_list[2] = 10'd32;
	spawn_position_list[3] = 10'd535;
	spawn_position_list[4] = 10'd181;
	spawn_position_list[5] = 10'd5;
	spawn_position_list[6] = 10'd260;
	spawn_position_list[7] = 10'd201;
	spawn_position_list[8] = 10'd532;
	spawn_position_list[9] = 10'd249;
	spawn_position_list[10] = 10'd116;
	spawn_position_list[11] = 10'd510;
	spawn_position_list[12] = 10'd32;
	spawn_position_list[13] = 10'd535;
	spawn_position_list[14] = 10'd181;
	spawn_position_list[15] = 10'd5;
	spawn_position_list[16] = 10'd260;
	spawn_position_list[17] = 10'd201;
	spawn_position_list[18] = 10'd532;
	spawn_position_list[19] = 10'd249;
	spawn_position_list[20] = 10'd333;
	spawn_position_list[21] = 10'd217;
	spawn_position_list[22] = 10'd376;
	spawn_position_list[23] = 10'd130;
	spawn_position_list[24] = 10'd35;
	spawn_position_list[25] = 10'd115;
	spawn_position_list[26] = 10'd583;
	spawn_position_list[27] = 10'd90;
	spawn_position_list[28] = 10'd243;
	spawn_position_list[29] = 10'd205;
	spawn_position_list[30] = 10'd429;
	spawn_position_list[31] = 10'd515;
	spawn_position_list[32] = 10'd88;
	spawn_position_list[33] = 10'd556;
	spawn_position_list[34] = 10'd348;
	spawn_position_list[35] = 10'd371;
	spawn_position_list[36] = 10'd298;
	spawn_position_list[37] = 10'd602;
	spawn_position_list[38] = 10'd386;
	spawn_position_list[39] = 10'd328;
	spawn_position_list[40] = 10'd203;
	spawn_position_list[41] = 10'd364;
	spawn_position_list[42] = 10'd270;
	spawn_position_list[43] = 10'd507;
	spawn_position_list[44] = 10'd366;
	spawn_position_list[45] = 10'd56;
	spawn_position_list[46] = 10'd83;
	spawn_position_list[47] = 10'd523;
	spawn_position_list[48] = 10'd476;
	spawn_position_list[49] = 10'd71;
	spawn_position_list[50] = 10'd324;
	spawn_position_list[51] = 10'd494;
	spawn_position_list[52] = 10'd480;
	spawn_position_list[53] = 10'd225;
	spawn_position_list[54] = 10'd579;
	spawn_position_list[55] = 10'd365;
	spawn_position_list[56] = 10'd7;
	spawn_position_list[57] = 10'd502;
	spawn_position_list[58] = 10'd394;
	spawn_position_list[59] = 10'd447;
	spawn_position_list[60] = 10'd346;
	spawn_position_list[61] = 10'd26;
	spawn_position_list[62] = 10'd289;
	spawn_position_list[63] = 10'd37;
	spawn_position_list[64] = 10'd513;
	spawn_position_list[65] = 10'd207;
	spawn_position_list[66] = 10'd8;
	spawn_position_list[67] = 10'd9;
	spawn_position_list[68] = 10'd68;
	spawn_position_list[69] = 10'd398;
	spawn_position_list[70] = 10'd104;
	spawn_position_list[71] = 10'd530;
	spawn_position_list[72] = 10'd52;
	spawn_position_list[73] = 10'd606;
	spawn_position_list[74] = 10'd136;
	spawn_position_list[75] = 10'd188;
	spawn_position_list[76] = 10'd357;
	spawn_position_list[77] = 10'd131;
	spawn_position_list[78] = 10'd399;
	spawn_position_list[79] = 10'd540;
	spawn_position_list[80] = 10'd51;
	spawn_position_list[81] = 10'd60;
	spawn_position_list[82] = 10'd214;
	spawn_position_list[83] = 10'd396;
	spawn_position_list[84] = 10'd226;
	spawn_position_list[85] = 10'd316;
	spawn_position_list[86] = 10'd254;
	spawn_position_list[87] = 10'd251;
	spawn_position_list[88] = 10'd134;
	spawn_position_list[89] = 10'd318;
	spawn_position_list[90] = 10'd237;
	spawn_position_list[91] = 10'd206;
	spawn_position_list[92] = 10'd48;
	spawn_position_list[93] = 10'd180;
	spawn_position_list[94] = 10'd241;
	spawn_position_list[95] = 10'd110;
	spawn_position_list[96] = 10'd144;
	spawn_position_list[97] = 10'd482;
	spawn_position_list[98] = 10'd145;
	spawn_position_list[99] = 10'd551;
end


always @(posedge SLOW_CLK) begin

	if (reset) begin

		game_over = 0;
		score = 0;
		max_score = 0;
		divider = 750000;

		obstacle0_start_y = 10'd0;
		obstacle1_start_y = 10'd64;
		obstacle2_start_y = 10'd128;
		obstacle3_start_y = 10'd192;
		obstacle4_start_y = 10'd256;

	end else begin
 
		spawn_position_index = spawn_position_index + 1;

		if (spawn_position_index >= 95) begin
			spawn_position_index = spawn_position_index - 95;
		end

		obstacle0_start_x = spawn_position_list[spawn_position_index + 1];
		obstacle1_start_x = spawn_position_list[spawn_position_index + 2];
		obstacle2_start_x = spawn_position_list[spawn_position_index + 3];
		obstacle3_start_x = spawn_position_list[spawn_position_index + 4];
		obstacle4_start_x = spawn_position_list[spawn_position_index + 5];

		// COLLISIONS
		// Deveria fazer um game over, mas estou só somando o score pra observar
		if (((player_x >= obstacle0_x) && (player_x <= obstacle0_x + obstacle_size_x) ||
		(player_x + player_size_x >= obstacle0_x) && (player_x + player_size_x <= obstacle0_x + obstacle_size_x)) &&
		(player_y >= obstacle0_y) && (player_y <= obstacle0_y + obstacle_size_y)) begin
			score = score + 1;
		end
		if (((player_x >= obstacle1_x) && (player_x <= obstacle1_x + obstacle_size_x) ||
		(player_x + player_size_x >= obstacle1_x) && (player_x + player_size_x <= obstacle1_x + obstacle_size_x)) &&
		(player_y >= obstacle1_y) && (player_y <= obstacle1_y + obstacle_size_y)) begin
			score = score + 1;
		end
		if (((player_x >= obstacle2_x) && (player_x <= obstacle2_x + obstacle_size_x) ||
		(player_x + player_size_x >= obstacle2_x) && (player_x + player_size_x <= obstacle2_x + obstacle_size_x)) &&
		(player_y >= obstacle2_y) && (player_y <= obstacle2_y + obstacle_size_y)) begin
			score = score + 1;
		end
		if (((player_x >= obstacle3_x) && (player_x <= obstacle3_x + obstacle_size_x) ||
		(player_x + player_size_x >= obstacle3_x) && (player_x + player_size_x <= obstacle3_x + obstacle_size_x)) &&
		(player_y >= obstacle3_y) && (player_y <= obstacle3_y + obstacle_size_y)) begin
			score = score + 1;
		end
		if (((player_x >= obstacle4_x) && (player_x <= obstacle4_x + obstacle_size_x) ||
		(player_x + player_size_x >= obstacle4_x) && (player_x + player_size_x <= obstacle4_x + obstacle_size_x)) &&
		(player_y >= obstacle4_y) && (player_y <= obstacle4_y + obstacle_size_y)) begin
			score = score + 1;
		end

	// Acelerar jogo até um limite
	divider = divider - 100;
	if (divider < 250000) divider = 250000;

	end
 
end

always @ (posedge CLOCK_50) begin
	red = ((obstacle0_drawing && obstacle0_color) || (obstacle1_drawing && obstacle1_color) ||
	(obstacle2_drawing && obstacle2_color) || (obstacle3_drawing && obstacle3_color) ||
	(obstacle4_drawing && obstacle4_color) || (player_drawing && player_color)) ? 255 : 0;
	blue = ((obstacle0_drawing && obstacle0_color) || (obstacle1_drawing && obstacle1_color) ||
	(obstacle2_drawing && obstacle2_color) || (obstacle3_drawing && obstacle3_color) ||
	(obstacle4_drawing && obstacle4_color) || (player_drawing && player_color)) ? 255 : 0;
	green = ((obstacle0_drawing && obstacle0_color) || (obstacle1_drawing && obstacle1_color) ||
	(obstacle2_drawing && obstacle2_color) || (obstacle3_drawing && obstacle3_color) ||
	(obstacle4_drawing && obstacle4_color) || (player_drawing && player_color)) ? 255 : 0;
end

endmodule