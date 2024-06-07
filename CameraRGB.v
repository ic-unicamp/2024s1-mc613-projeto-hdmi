module CameraRGB(
	input pclk,
	input reset,
	input cam_vsync,
	input href,
	input [2:0] crc,
	input [2:0] cbc,
	input [7:0] pixel,
	output [9:0] next_x,
	output [9:0] next_y,
	output reg wren,
	output reg [17:0] rgb
);

reg [2:0] state;
parameter [2:0] WAIT_VSYNC_DOWN = 1;
parameter [2:0] WAIT_VSYNC_UP = 0;
parameter [2:0] COUNT = 2;

reg [9:0] x = 0;
reg [9:0] y = 0;

reg [7:0] ipsilonzero;
reg [7:0] ipsilonum;
reg [7:0] cr;
reg [7:0] cb; 
reg [17:0] red;	
reg [17:0] green;	
reg [17:0] blue;	

assign next_x = (x < 640) ? x - 1 : 639;
assign next_y = y;

reg half_clk = 0;
reg [1:0] bit = 0;

//assign wren = (bit == 0 && href) ? 1 : 0;

//always @(posedge pclk) begin
//	if(reset) begin
//		half_clk = 0;
//	end else  	begin
//		half_clk = !half_clk;
//	end
//end

always @(posedge pclk) begin
	if (reset) begin
		state = 0;
		x = 0;
		y = 0;
		bit = 0;
		wren = 0;
		rgb = 0;
	end else begin
		case(state)
			WAIT_VSYNC_UP: begin
				if(cam_vsync == 1) state = WAIT_VSYNC_DOWN;
			end
			WAIT_VSYNC_DOWN: begin
				x = 0;
				y = 0;
				wren = 0;
				if(cam_vsync == 0) begin
					state = COUNT;
					bit = 0;
				end
			end
			COUNT: begin
				if(href) begin
					bit = bit + 1;
					wren = 0;
					if(bit == 1) begin 
						cb = pixel;
						x = x + 1;
					end
					if(bit == 2) begin 
						ipsilonzero = pixel;
					end
					if(bit == 3) begin 
						cr = pixel;
						x = x + 1;
					end
					if(bit == 0) begin
						ipsilonum = pixel;
						red = (y * 1024) + (1435*(cr));
						green = (y * 1024) - (352*(cb)) - (731*(cr));
						blue = (y * 1024) + (1814*(cb));
						rgb = {red[17:15], green[17:15], blue[17:15], red[17:15], green[17:15], blue[17:15]};
						//if(cr > 150 && cb > 150 && ipsilonzero > 100) rgb = 18'b000111000000111000;
						//else rgb = {cr[7:5], cr[7:5], cr[7:5], cr[7:5], cr[7:5], cr[7:5]};
						//rgb = {1'b0, cr, 1'b0, cr};
						wren = 1;
					end
				end
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