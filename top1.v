module top1 (
	input CLOCK_50,
	input [3:0] KEY,
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

wire reset = !KEY[0];
wire[7:0] pixel;
assign pixel = GPIO_0[7:0];
assign GPIO_0[8] = CLOCK_24;
wire href;
wire cam_vsync;
assign href = GPIO_0[10];
assign cam_vsync = GPIO_0[11];
wire pclk;
assign pclk = GPIO_0[9];

wire [9:0] next_x_vga;
wire [9:0] next_y_vga;
wire wren;
wire [7:0] vga_out;
wire [9:0] next_x_cam;
wire [9:0] next_y_cam;


pll24 pll_inst (
	.refclk   (CLOCK_50),   //  refclk.clk
	.rst      (reset),      //   reset.reset
	.outclk_0 (CLOCK_24), // outclk0.clk
	.locked   ()    //  locked.export
);

vga vga_inst(
  .reset(reset),
  .CLOCK_50(CLOCK_50),
  .red(vga_out),
  .green(vga_out),
  .blue(vga_out),
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

Camera camera(
	.pclk(pclk),
	.reset(reset),
	.href(href),
	.wren(wren),
	.cam_vsync(cam_vsync),
	.next_x(next_x_cam),
	.next_y(next_y_cam)
);

Buffer buffer(
	.wrclk(pclk),
	.rdclk(VGA_CLK),
	.wraddress_x(next_x_cam),
	.wraddress_y(next_y_cam),
	.write_data(pixel),
	.wren(wren),
	.rdaddress_x(next_x_vga),
	.rdaddress_y(next_y_vga),
	.read_data(vga_out)
);

endmodule