module Projeto (
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output CLOCK_24,
	inout [35:0] GPIO_0,
	output VGA_CLK,
   output VGA_HS,
	output VGA_VS,	
	output [7:0] VGA_R,
	output [7:0] VGA_G,
	output [7:0] VGA_B,
	output VGA_BLANK_N,
	output VGA_SYNC_N
);

wire cbc = SW[9:7];
wire crc = SW[6:4]; 
wire reset = !KEY[0];
wire start = !KEY[3];
wire resetsccb = !KEY[1];
wire[7:0] pixel;
assign pixel = GPIO_0[7:0];
assign GPIO_0[8] = CLOCK_24;
wire href;
wire cam_vsync;
assign href = GPIO_0[10];
assign cam_vsync = GPIO_0[11];
wire pclk;
assign pclk = GPIO_0[9];
assign sio_d = GPIO_0[24];
assign sio_c = GPIO_0[25];

wire [9:0] next_x_vga;
wire [9:0] next_y_vga;
wire wren;
wire [8:0] vga_out;
wire [9:0] next_x_cam;
wire [9:0] next_y_cam;

pll pll_inst (
	.refclk   (CLOCK_50),   //  refclk.clk
	.rst      (reset),      //   reset.reset
	.outclk_0 (CLOCK_24), // outclk0.clk
	.locked   ()    //  locked.export
);

wire [18:0] next_cam;
wire [18:0] next_vga;

assign next_cam = next_x_cam + (640 * next_y_cam);
assign next_vga = next_x_vga + (640 * next_y_vga);

wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;
wire [17:0] rgb;

vga vga_inst(
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
  .next_x(next_x_vga),
  .next_y(next_y_vga),
  .line()
);

CameraRGB camera(
	.pclk(pclk),
	.reset(reset),
	.href(href),
	.wren(wren),
	.pixel(pixel),
	.cam_vsync(cam_vsync),
	.next_x(next_x_cam),
	.next_y(next_y_cam),
	.rgb(rgb),
	.cbc(cbc),
	.crc(crc)
);

Buffer buffer(
	.wrclk(pclk),
	.rdclk(VGA_CLK),
	.wraddress(next_cam),
	.write_data(rgb),
	.wren(wren),
	.rdaddress(next_vga),
	.read_data(vga_out)
);

//assign red = vga_out[7:0];
//assign green = vga_out[7:0];
//assign blue = vga_out[7:0];

assign red = {vga_out[8:6], 5'b00000};
assign green = {vga_out[5:3], 5'b00000};
assign blue = {vga_out[2:0], 5'b00000};

endmodule