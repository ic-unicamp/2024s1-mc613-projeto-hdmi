module Camera(
	input pclk,
	input reset,
	input cam_vsync,
	input href,
	output [9:0] next_x,
	output [9:0] next_y,
	output wren
);

reg [2:0] state;
parameter [2:0] WAIT_VSYNC_DOWN = 1;
parameter [2:0] WAIT_VSYNC_UP = 0;
parameter [2:0] COUNT = 2;

reg [9:0] x = 0;
reg [9:0] y = 0;

assign next_x = (x < 640) ? x - 1 : 639;
assign next_y = y;

reg half_clk = 0;
reg bit = 0;

assign wren = bit && href;

always @(posedge pclk) begin
	if(reset) begin
		half_clk = 0;
		bit = 1;
	end else begin
		if(cam_vsync) bit = 1;
		bit = !bit;
		half_clk = !half_clk;
	end
end

always @(posedge half_clk) begin
	if (reset) begin
		state = 0;
		x = 0;
		y = 0;
	end else begin
		case(state)
			WAIT_VSYNC_UP: begin
				if(cam_vsync == 1) state = WAIT_VSYNC_DOWN;
			end
			WAIT_VSYNC_DOWN: begin
				x = 0;
				y = 0;
				if(cam_vsync == 0) begin
					state = COUNT;
				end
			end
			COUNT: begin
				if(href) x = x + 1;
				if(x == 640) begin
					x = 0;
					y = y + 1;
				end
				if(cam_vsync == 1) state = WAIT_VSYNC_DOWN;
			end
		endcase
	end
end


endmodule