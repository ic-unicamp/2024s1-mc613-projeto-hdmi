module spriteBarra (
	input clk,
	input reset,
	input vsync,
	input [9:0] x, y, sprite_x, sprite_y,
	output reg color,
	output reg drawing
);

parameter [9:0] sprite_width = 64;
parameter [9:0] sprite_height = 8;

reg [9:0] sprite_x_reg, sprite_y_reg;
always @ (negedge vsync) begin
	sprite_x_reg = sprite_x;
	sprite_y_reg = sprite_y;
end 
reg sprite_active_y, sprite_active_x, sprite_end, line_end;

always @ (x, y) begin
	sprite_active_y = (y >= sprite_y_reg) && (y < sprite_y_reg + sprite_height);
	sprite_active_x = (x >= sprite_x_reg) && (x < sprite_x_reg + sprite_width);
	drawing = (sprite_active_y && sprite_active_x) ? 1 : 0;
	color = (sprite_active_y && sprite_active_x) ? 1 : 0;
end

endmodule