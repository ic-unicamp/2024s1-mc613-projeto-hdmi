module spriteNave (
	input clk,
	input reset,
	input [9:0] x, y, sprite_x, sprite_y,
	input vsync,
	output reg color,
	output reg drawing
);

parameter [6:0] sprite_width = 32;
parameter  sprite_height = 16;
reg [0:sprite_width-1] bmap [sprite_height];
initial begin
	bmap[0]   = 32'b00000000_00000001_10000000_00000000;
	bmap[1]   = 32'b00000000_00000111_11100000_00000000;
	bmap[2]   = 32'b00000000_00001111_11110000_00000000;
	bmap[3]   = 32'b00000000_00011111_11111000_00000000;
	bmap[4]   = 32'b00000000_00011111_11111000_00000000;
	bmap[5]   = 32'b00000000_00111111_11111100_00000000;
	bmap[6]   = 32'b00000000_00111111_11111100_00000000;
	bmap[7]   = 32'b00111110_01111111_11111110_01111100;
	bmap[8]   = 32'b11111111_11111111_11111111_11111111;
	bmap[9]   = 32'b11111111_11111111_11111111_11111111;
	bmap[10]  = 32'b11111111_11111111_11111111_11111111;
	bmap[11]  = 32'b00111110_01111111_11111110_01111100;
	bmap[12]  = 32'b00011110_01111111_11111110_01111000;
	bmap[13]  = 32'b00011110_00111111_11111100_01111000;
	bmap[14]  = 32'b00011110_00011111_11111000_01111000;
	bmap[15]  = 32'b00000000_00000011_11000000_00000000;
end

reg [$clog2(sprite_width)-1:0] bmap_x;
reg [$clog2(sprite_height)-1:0] bmap_y;

reg [9:0] sprite_x_reg, sprite_y_reg;
always @ (negedge vsync) begin
	sprite_x_reg = sprite_x;
	sprite_y_reg = sprite_y;
end 

reg sprite_active_y, sprite_active_x, sprite_end, line_end;

always @ (x, y) begin
	sprite_active_y = (y >= sprite_y_reg) && (y < sprite_y_reg + sprite_height);
	sprite_active_x = (x >= sprite_x_reg) && (x < sprite_x_reg + sprite_width);
	bmap_x = x - sprite_x_reg;
	bmap_y = y - sprite_y_reg;
	drawing = (sprite_active_y && sprite_active_x) ? 1 : 0;
	color = (sprite_active_y && sprite_active_x) ? bmap[bmap_y][bmap_x] : 0;
end

endmodule